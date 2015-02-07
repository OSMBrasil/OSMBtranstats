require 'transifex'
require 'yaml'

config = YAML.load_file('config.yml')

class ItemParser
    def ItemParser.factory item
        if item[:type] == :transifex then
            TransifexParser.new item
        else
            ItemParser.new item
        end
    end
    def initialize(item)
        @item = item
    end
    def result
        name = @item[:name]
        message = @item[:default]
        return name, message
    end
end

class TransifexParser < ItemParser
    @@client = nil
    def self.client=client
        @@client = client
    end
    def result
        name, message = super
        project = @@client.project(@item[:project])
        if @item[:resource] != nil then
            resource = project.resource(@item[:resource])
            stats = resource.stats(:pt_BR)
            message = stats.completed
        else
            translated_words = 0
            untranslated_words = 0
            project.resources.each do |resource|
                stats = resource.stats(:pt_BR)
                translated_words += stats.translated_words
                untranslated_words += stats.untranslated_words
            end
            total_words = translated_words + untranslated_words
            percent = (translated_words.to_f / total_words) * 100
            message = percent.round.to_s + '%'
        end
        return name, message
    end
end

class SourcesPrinter
    def initialize(config)
        @config = config
        TransifexParser.client = Transifex::Client.new(
            username: @config['credentials']['transifex']['user'],
            password: @config['credentials']['transifex']['pass']
        )
    end
    def print_header
        puts '<noinclude>'
        puts @config['ui']['info']
        puts '</noinclude>{| class="wikitable" style="text-align: center;"'
        puts '|+ ' + @config['ui']['title']
        puts '|-'
        puts '!' + @config['ui']['columns']['tool']
        puts '!' + @config['ui']['columns']['status']
        puts '!' + @config['ui']['columns']['date']
    end
    def print_sources
        date = Time.new.strftime('%d-%m-%Y')
        @config["sources"].each do |item|
            parser = ItemParser.factory item
            name, message = parser.result
            puts '|-'
            puts '|' + name
            puts '|' + message
            puts '|' + date
        end
    end
    def print_footer
        puts '|}'
    end
    def execute
        print_header
        print_sources
        print_footer
    end
    private :print_header, :print_sources, :print_footer
end

begin
    printer = SourcesPrinter.new(config)
    printer.execute
rescue Transifex::NotFound, URI::InvalidURIError => e
    puts
    puts e.to_yaml
    puts
end

