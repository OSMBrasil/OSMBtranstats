**OSMBtranstats** é o nome deste projeto que organiza-se em volta do script `get_stats.rb` e do arquivo de configurações [config.yml](config.yml). Quer significar "OpenStreetMap Brazil/Basic Translations's Statistics". São estatísticas básicas de traduções de software na comunidade [OpenStreetMap Brasil](http://www.openstreetmap.com.br).

O uso do script reduz o tempo de manutenção da página wiki de [situação](http://wiki.openstreetmap.org/wiki/WikiProject_Brazil/Tradu%C3%A7%C3%B5es/Situa%C3%A7%C3%A3o) das traduções brasileiras a alguns segundos ou menos de dois minutos, dependendo da qualidade da conexão à Internet.

_**Intenções que estão colocadas de lado mas são facilmente realizáveis:** internacionalionalizar o projeto, com algumas pequenas alterações no código (que hoje recebe/trata apenas pt-br, pt_BR ou pt), possibilitando que comunidades de outros países o reutilizem._

# Dependências

- Git, para baixar os arquivos com mais praticidade
- **Ruby**, a linguagem de programação
- [Bundler](http://bundler.io), para empacotar alguma dependência
- Bibliotecas de software
 -  [transifex-ruby](/tmaesaka/transifex-ruby), lib para autenticar e colher dados no Transifex
 - [nokogiri](/sparklemotion/nokogiri), lib para colher dados em páginas HTML
 - [yamldiff](/alexandre-mbm/yamldiff), lib que extendemos para contar diferenças entre arquivos YAML

# Instalar

Não é exatamente "instalação". Só das dependências, e colocar os arquivos num diretório.

**No Ubuntu**

```console
$ sudo apt-get install git
$ sudo apt-get install ruby ruby-nokogiri
$ sudo apt-get install bundler

$ cd TEMP_DIR/
$ git clone https://github.com/tmaesaka/transifex-ruby.git
$ cd transifex-ruby
$ gem build transifex-ruby.gemspec
$ sudo gem install transifex-ruby-0.0.4.gem

$ cd TEMP_DIR/
$ git clone https://github.com/alexandre-mbm/yamldiff.git
$ cd yamldiff
$ bundle
$ gem build yamldiff.gemspec
$ sudo gem install yamldiff-0.0.10.gem

$ cd ~
$ https://github.com/OSMBrasil/OSMBtranstats.git
$ cd OSMBtranstats
```
Rotina pensada para Ubuntu 14.04 LTS mas não testada.

**No Windows**

- Instale Git para Windows: [msysGit](http://msysgit.github.io)
- Instale Ruby no Windows: [RubyInstaller](http://rubyinstaller.org)
- Siga as **[dicas](WINDOWS.md)** para a instalação dos gems necessários
- Este ambiente está validado, tendo sido o berço do projeto

# Como usar

1) Configure o [config.yml](config.yml) com suas credenciais Transifex

2) Execute
```console
$ ruby get_stats.rb > stats.txt
```

3) Copie o conteúdo de **stats.txt** para edição de [WikiProject Brazil/Traduções/Situação](https://wiki.openstreetmap.org/w/index.php?title=WikiProject_Brazil/Tradu%C3%A7%C3%B5es/Situa%C3%A7%C3%A3o&action=edit)

4) Revise as alterações e salve a página

# Licença

Dedicamos esta ferramenta ao **domínio público** através de [CCO 1.0](https://creativecommons.org/publicdomain/zero/1.0/deed.pt_BR) (arquivo [LICENSE](LICENSE)).

Nossas três [dependências diretas](WINDOWS.md) são liberadas sob a [Expat License](http://en.wikipedia.org/wiki/Expat_License), também conhecida ambiguamente como [MIT License](http://choosealicense.com/licenses/mit/); existe mais de uma "licença do MIT".

Ruby 2.x está sob licença dupla: [Ruby License](http://www.ruby-lang.org/en/about/license.txt) / [FreeBSD License](http://pt.wikipedia.org/wiki/Licen%C3%A7a_BSD) (conhecida como 2-clause BSDL).

Bundler é ferramenta disponibilizada sob a [Expat License](http://en.wikipedia.org/wiki/Expat_License).