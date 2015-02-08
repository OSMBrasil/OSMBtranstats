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

class TranslatewikiCollector
    @@url_template = 'https://translatewiki.net/w/i.php?title=Special:MessageGroupStats&group=%s'
    def initialize(project, language = 'pt-br')
        @language = language
        @url = @@url_template % project
        @doc = Nokogiri::HTML(open(@url))
        execute
    end
    def test
        @doc.css('table.statstable tbody tr td a[href$="pt-br"]').each do |item|
            parent = item.parent
            puts parent.next_element
            #puts item.next_sibling.next_sibling
        end
    end
    def completed
        @translated_frac.to_f * 100
    end
    '''
	<tr>
		<td><a href="/w/i.php?title=Special:Translate&amp;action=proofread&amp;group=out-osm-site&amp;language=pt-br" title=Special:Translate>pt-br: português do Brasil</a></td>
		<td data-sort-value=1692>1 692</td>
		<td data-sort-value=0>0</td>
		<td data-sort-value=1.00000 style="background-color: #00FF00" class=hover-color>100%</td>
		<td data-sort-value=0.00000 style="background-color: #00FF00" class=hover-color>0%</td>
	</tr>
    '''
    def execute
        @doc.css('table.statstable tbody tr td a[href$="pt-br"]').each do |item|
            parent = item.parent
            node1 = parent.next_element
            node2 = node1.next_element
            node3 = node2.next_element
            node4 = node3.next_element
            @translated_count = node1['data-sort-value']
            @untranslated_count = node2['data-sort-value']
            @translated_frac = node3['data-sort-value']
            @untranslated_frac = node4['data-sort-value']
            break  # should be one only
        end
    end
    private :execute
end

if caller.length == 0
    collector = TranslatewikiCollector.new 'out-osm-site'
    puts collector.completed  # 100.0
    exit
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

