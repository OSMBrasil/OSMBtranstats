require 'transifex'
require 'yaml'

config = YAML.load_file('config.yml')

transifex = Transifex::Client.new(username: config['user'], password: config['pass'])

date = Time.new.strftime('%d-%m-%Y')

puts '''{| class="wikitable" style="text-align: center;"
|+ Situação das Traduções
|-
!Ferramenta
!Situação
!Verificado em
'''

begin
    config["sources"].each do |item|
        name = item[:name]
        if item[:type] == :transifex then
            project = transifex.project(item[:project])
            if item[:resource] != nil then
                resource = project.resource(item[:resource])
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
        else
            message = item[:default]
        end
        puts '|-'
        puts '|' + name
        puts '|' + message
        puts '|' + date
    end
rescue Transifex::NotFound, URI::InvalidURIError => e
    puts
    puts e.to_yaml
    puts
end

puts '|}'
