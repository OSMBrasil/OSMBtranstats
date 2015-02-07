require 'open-uri'
require 'json'

class TaginfoCollector
    @@url_template = 'http://%s/api/%s/wiki/languages'
    def initialize(project, language = 'pt-br', api_version = '4')
        @url = @@url_template % [project, api_version]
        @language = language
        @api_version = api_version
        @json = JSON.load(open(@url))
        execute
    end
    def completed_keys
        @keys_frac.to_f * 100
    end
    def completed_tags
        @tags_frac.to_f * 100
    end
    def execute
        @json['data'].each do |entry|
            if entry['code'] == @language
                #puts entry
                @keys_frac = entry['wiki_key_pages_fraction'] # 0.1123052122514777
                @tags_frac = entry['wiki_tag_pages_fraction'] # 0.014241055922195206
                break
            end
        end
    end
    def test
        puts @json.to_s
    end
    private :execute
end

if caller.length == 0
    collector = TaginfoCollector.new 'taginfo.openstreetmap.org'
    puts collector.completed_keys
    puts collector.completed_tags
end

