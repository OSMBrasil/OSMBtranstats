require 'open-uri'
require 'yaml'
#require 'diffy'
require 'yamldiff'

class RemoteYamldiff < Yamldiff
    class << self
        def diff_yaml(first, second, errors_for = {})
            primary            = YAML.parse(open(first)).to_ruby
            secondary          = YAML.parse(open(second)).to_ruby
            errors_for[second] = compare_hashes(primary, secondary)
            errors_for
        end
    end
end

class RemoteYamlcomm < Yamlcomm
    class << self
        def comm_yaml(first, second, common = [])
            primary            = YAML.parse(open(first)).to_ruby
            secondary          = YAML.parse(open(second)).to_ruby
            common = compare_hashes(primary, secondary)
            common
        end
    end
end

class CodedYamldiff < Yamldiff
    class << self
        def diff_yaml(first, second, errors_for = {}, label)
            primary            = first
            secondary          = second
            errors_for[label] = compare_hashes(primary, secondary)
            errors_for
        end
    end
end

class CodedYamlcomm < Yamlcomm
    class << self
        def comm_yaml(first, second, common = [])
            primary            = first
            secondary          = second
            common = compare_hashes(primary, secondary)
            common
        end
    end
end

class FileCollector
    def initialize(resource_orig, resource_dest)
        @url_orig = resource_orig
        @url_dest = resource_dest
        load_files
        process
    end
    def completed
        'unknown'
    end
    def load_files
        # to implement at subclasss of edge
    end
    def process
        # to implement at subclasss of edge
    end
    protected :load_files, :process
end

class GithubCollector < FileCollector
    @@url_template = 'https://raw.githubusercontent.com/%s/%s/%s'
    def initialize(project, resource_orig, resource_dest, branch = 'master')
        url_orig = @@url_template % [project, branch, resource_orig]
        url_dest = @@url_template % [project, branch, resource_dest]
        super url_orig, url_dest
    end
end

class GithubYAML_Collector < GithubCollector
    def completed
    end
    def load_files
        #@orig = YAML.load(ERB.new('en.coffee').result)
        @orig = YAML.parse(open(@url_orig)).to_ruby
        @dest = YAML.parse(open(@url_dest)).to_ruby
    end
    def compute_keys_missing(errors)
        count = 0
        errors.each do |error|
            if error.instance_of? YamldiffKeyError
                count += 1
            end
        end
        count
    end
    def process
        errors = {}
        errors = CodedYamldiff.diff_yaml(@orig, @dest, errors, :dest)
        #errors = CodedYamldiff.diff_yaml(@dest, @orig, errors, :orig)
        common = CodedYamlcomm.comm_yaml(@orig, @dest)
        keys_missing_count = compute_keys_missing(errors[:dest])
        diff_errors_count = errors[:dest].length
        common_count = common.length
        @total_of_keys = diff_errors_count + common_count
        @translated_keys = diff_errors_count - keys_missing_count
        @untranslated_keys = keys_missing_count + common_count
    end
    def completed
        (@translated_keys.to_f / @total_of_keys) * 100
    end
    '''
        common.length: key and value in the two files
        
        YamldiffError
            YamldiffKeyError: lacks the key in the second file
            YamldiffKeyValueTypeError: for same key, values of different types in the two files
            YamldiffKeyValueError: for same key, different values in the two files
    '''
    def test_coded
        errors = {}
        errors = CodedYamldiff.diff_yaml(@orig, @dest, errors, :dest)
        errors = CodedYamldiff.diff_yaml(@dest, @orig, errors, :orig)
        common = CodedYamlcomm.comm_yaml(@orig, @dest)
        puts errors[:dest].length  # 186
        puts errors[:orig].length  # 186
        puts common.length         #  12 - example with Mapillary
    end
    def test
        puts @url_orig
        puts @url_dest
        #url_one = @url_orig
        #url_two = @url_dest
        url_one = @url_dest
        url_two = @url_orig
        errors = RemoteYamldiff.diff_yaml(url_one, url_two)[url_two].length
        puts errors
    end
    protected :load_files, :process
    private :compute_keys_missing
end

#https://raw.githubusercontent.com/mapillary/mapillary_localization/master/locales/pt-BR.coffee

if caller.length == 0
    collector = GithubYAML_Collector.new(
        'mapillary/mapillary_localization',
        'locales/en.coffee',
        'locales/pt-BR.coffee'
    )
    #collector.test
    #collector.test_coded
    puts collector.completed
end
