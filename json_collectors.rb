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

class WeblateCollector
    # https://hosted.weblate.org/exports/stats/osmand/main/?indent=4
    @@url_template = 'https://hosted.weblate.org/exports/stats/%s/%s/'
    def initialize(project, component, language = 'pt')
        @url = @@url_template % [project, component]
        @language = language
        @json = JSON.load(open(@url))
        execute
    end
    def completed
        @translated_percent
    end
    '''
    {
        "last_author": "Tarcisio Oliveira",
        "code": "pt",
        "failing_percent": 0.9,
        "total_words": 11119,
        "translated_words": 10427,
        "url_translate": "https://hosted.weblate.org/projects/osmand/main/pt/",
        "fuzzy": 104,
        "total": 1624,
        "name": "Portuguese",
        "url": "https://hosted.weblate.org/engage/osmand/pt/",
        "translated_percent": 91.6,
        "failing": 16,
        "fuzzy_percent": 6.4,
        "translated": 1488,
        "last_change": "2015-02-06T02:42:06"
    },
    '''
    def execute
        @json.each do |entry|
            if entry['code'] == @language
                #puts entry
                @translated_percent = entry['translated_percent'] # 91.6
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
    collector = WeblateCollector.new 'osmand', 'main'
    puts collector.completed
    exit
end

if caller.length == 0
    collector = TaginfoCollector.new 'taginfo.openstreetmap.org'
    puts collector.completed_keys
    puts collector.completed_tags
end

