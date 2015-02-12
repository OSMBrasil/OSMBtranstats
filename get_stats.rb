require 'transifex'
require 'yaml'

load 'noko_collectors.rb'
load 'json_collectors.rb'
load 'file_collectors.rb'

load 'decorators.rb'

config = YAML.load_file('config.yml')

class ItemParser
    def ItemParser.factory item
        case item[:type]
            when :transifex
                TransifexParser.new item
            when :launchpad
                LaunchpadParser.new item
            when :taginfo
                TaginfoParser.new item
            when :translatewiki
                TranslatewikiParser.new item
            when :weblate
                WeblateParser.new item
            when :github_yaml
                GithubYAML_Parser.new item
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
    def percentage_formatted(value, precision = 1)  # 92.324 or 92.324%
        rounded = value.to_s.delete('%').to_f.round(precision)  # 92.3
        integer = rounded.round
        return rounded.to_s + '%' unless rounded - integer == 0
        return integer.to_s + '%'
    end
    private :percentage_formatted
end

class SpecializedParser < ItemParser
    @@client = nil
    def self.client=client
        @@client = client
    end
end

class TransifexParser < SpecializedParser
    def result
        name, message = super
        project = @@client.project(@item[:project])
        if @item[:resource] != nil then
            resource = project.resource(@item[:resource])
            stats = resource.stats(:pt_BR)
            message = percentage_formatted(stats.completed)
        else
            translated_entities = 0
            untranslated_entities = 0
            project.resources.each do |resource|
                stats = resource.stats(:pt_BR)
                translated_entities += stats.translated_entities
                untranslated_entities += stats.untranslated_entities
            end
            total_entities = translated_entities + untranslated_entities
            percent = (translated_entities.to_f / total_entities) * 100
            message = percentage_formatted(percent)
        end
        return name, message
    end
end

class LaunchpadParser < ItemParser
    def result
        name, message = super
        if @item[:resource] == nil then
            launchpad = LaunchpadCollector.new @item[:project]
        else
            launchpad = LaunchpadCollector.new @item[:project], @item[:resource]
        end
        message = percentage_formatted(launchpad.completed)
        return name, message
    end
end

class TaginfoParser < ItemParser
    def result
        name, message = super
        taginfo = TaginfoCollector.new @item[:project]
        keys_percent = percentage_formatted(taginfo.completed_keys, 2)
        tags_percent = percentage_formatted(taginfo.completed_tags, 2)
        message = 'keys %s / tags %s' % [keys_percent, tags_percent]
        return name, message
    end
end

class TranslatewikiParser < ItemParser
    def result
        name, message = super
        translatewiki = TranslatewikiCollector.new @item[:project]
        message = percentage_formatted(translatewiki.completed)
        return name, message
    end
end

class WeblateParser < ItemParser
    def result
        name, message = super
        weblate = WeblateCollector.new @item[:project], @item[:resource]
        message = percentage_formatted(weblate.completed)
        return name, message
    end
end

class GithubYAML_Parser < ItemParser
    def result
        name, message = super
        github_yaml = GithubYAML_Collector.new(
            @item[:project],
            @item[:resource_orig],
            @item[:resource_dest]
        )
        message = percentage_formatted(github_yaml.completed)
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
            decorator = MediawikiDecorator.factory item
            name, message = parser.result
            message = decorator.decorate_message(message)
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

