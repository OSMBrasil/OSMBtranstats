require 'open-uri'
require 'nokogiri'

class LaunchpadCollector
    @@url_template = 'https://translations.launchpad.net/%s/trunk/+pots/%s/%s/+details'
    def initialize(project, resource = project, language = 'pt_BR')
        @url = @@url_template % [project, resource, language]
        @doc = Nokogiri::HTML(open(@url))
        execute
    end
    def test
        @doc.css('#portlet-stats b').each do |item|
            puts item.text
            puts item.next_sibling.text
        end
    end
    def completed
        @translated_percent.delete('(').delete(')')
    end
    def execute
        i = @doc.css('#portlet-stats b')
        @messages_count = array_of_values_for_item i[0]        
        translated_result = array_of_values_for_item i[1]
        @translated_count = translated_result[0]
        @translated_percent = translated_result[1]        
        untranslated_result = array_of_values_for_item i[2]
        @untranslated_count = untranslated_result[0]
        @untranslated_percent = untranslated_result[1]
        only_launchpad_result = array_of_values_for_item i[6]
        @only_translated_on_launchpad_count = only_launchpad_result[0]
        @only_translated_on_launchpad_percent = only_launchpad_result[1]
    end
    def array_of_values_for_item(i, size = 2)
        i.next_sibling.text.delete(' ').lines.map(&:chomp)[1,2]
    end
    private :execute, :array_of_values_for_item
end

# it is not called by load or require statements
# http://stackoverflow.com/a/19370576
#
if caller.length == 0
    # ex.: http://translations.launchpad.net/keepright/trunk/+pots/keepright/pt_BR/+details
    collector = LaunchpadCollector.new 'keepright'
    #collector.test
    puts collector.completed
end

