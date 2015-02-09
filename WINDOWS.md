Como estudo de caso, o primeiro autor do script resolveu usar Ruby e Git no Windows, através do console [MSYS2](http://msys2.github.io). Mas nesta página somente é abordado o que se refere às dependências Ruby do OSMBtranstats.

Dependências que precisam ser instaladas como extra:

1. [transifex-ruby](#transifex-ruby)
1. [nokogiri](#nokogiri)
1. [yamldiff](#yamldiff)

# transifex-ruby

O [código](https://github.com/tmaesaka/transifex-ruby) está no GitHub. Como inicialmente o projeto  OSMBtranstats não resulta num gem, o mais prático é (1) clonar o repositório, (2) gerar manualmente o gem daquela dependência e (3) instalá-la.

1) Clonar o repositório GitHub da dependência

````console
$ git clone https://github.com/tmaesaka/transifex-ruby.git
```

E entrar no diretório de repositório clonado:
````console
$ cd transifex-ruby
```

2) [Gerar](http://guides.rubygems.org/make-your-own-gem/) o gem da dependência: `gem build transifex-ruby.gemspec`

```console
$ gem build transifex-ruby.gemspec
WARNING:  description and summary are identical
WARNING:  pessimistic dependency on faraday (~> 0.8.0) may be overly strict
  if faraday is semantically versioned, use:
    add_runtime_dependency 'faraday', '~> 0.8', '>= 0.8.0'
WARNING:  pessimistic dependency on faraday_middleware (~> 0.9.0) may be overly strict
  if faraday_middleware is semantically versioned, use:
    add_runtime_dependency 'faraday_middleware', '~> 0.9', '>= 0.9.0'
WARNING:  pessimistic dependency on hashie (~> 1.2.0) may be overly strict
  if hashie is semantically versioned, use:
    add_runtime_dependency 'hashie', '~> 1.2', '>= 1.2.0'
WARNING:  open-ended dependency on rake (>= 0, development) is not recommended
  if rake is semantically versioned, use:
    add_development_dependency 'rake', '~> 0'
WARNING:  open-ended dependency on rspec (>= 0, development) is not recommended
  if rspec is semantically versioned, use:
    add_development_dependency 'rspec', '~> 0'
WARNING:  open-ended dependency on guard-rspec (>= 0, development) is not recommended
  if guard-rspec is semantically versioned, use:
    add_development_dependency 'guard-rspec', '~> 0'
WARNING:  open-ended dependency on webmock (>= 0, development) is not recommended
  if webmock is semantically versioned, use:
    add_development_dependency 'webmock', '~> 0'
WARNING:  open-ended dependency on pry (>= 0, development) is not recommended
  if pry is semantically versioned, use:
    add_development_dependency 'pry', '~> 0'
WARNING:  See http://guides.rubygems.org/specification-reference/ for help
  Successfully built RubyGem
  Name: transifex-ruby
  Version: 0.0.4
  File: transifex-ruby-0.0.4.gem
```

A saída do comando tem vários WARNING, o que pode parecer estranho. Mas é tudo por que as versões dos gems que são dependência do transifex-ruby não estão melhor especificadas.

3) Instalar a dependência: `gem install transifex-ruby-0.0.4.gem`

```console
$ gem install transifex-ruby-0.0.4.gem

Successfully installed multipart-post-1.2.0
Successfully installed faraday-0.8.9
Successfully installed faraday_middleware-0.9.1
Successfully installed hashie-1.2.0
Successfully installed transifex-ruby-0.0.4
Parsing documentation for faraday-0.8.9
Installing ri documentation for faraday-0.8.9
Parsing documentation for faraday_middleware-0.9.1
Installing ri documentation for faraday_middleware-0.9.1
Parsing documentation for hashie-1.2.0
Installing ri documentation for hashie-1.2.0
Parsing documentation for multipart-post-1.2.0
Installing ri documentation for multipart-post-1.2.0
Parsing documentation for transifex-ruby-0.0.4
Installing ri documentation for transifex-ruby-0.0.4
Done installing documentation for faraday, faraday_middleware, hashie, multipart-post, transifex-ruby after 5 seconds
5 gems installed
```
Agora ficou entendido que o transifex-ruby precisava instalar quatro dependências: multipart-pos, faraday, faraday_middleware, hashie. Isso foi feito automaticamente, a partir da Internet!

# nokogiri

1) Fazer download de [nokogiri-1.6.5-x86-mingw32.gem](http://www.nokogiri.org/tutorials/installing_nokogiri.html#windows) **ou substituto**\*

&nbsp;&nbsp;&nbsp;&nbsp;_\* Você usa 64 bits?_

Esses arquivos vem preparados já embutindo as DLLs requeridas pelo Windows. Preferir o comando o `gem install nokogiri` exigiria o DevKit configurado previamente, para compilação de código nativo.

2) Instalar: `gem install nokogiri-1.6.5-x86-mingw32.gem`

```console
$ gem install nokogiri-1.6.5-x86-mingw32.gem
Nokogiri is built with the packaged libraries: libxml2-2.9.2, libxslt-1.1.28, zlib-1.2.8, libiconv-1.14.
Successfully installed nokogiri-1.6.5-x86-mingw32
Parsing documentation for nokogiri-1.6.5-x86-mingw32
Installing ri documentation for nokogiri-1.6.5-x86-mingw32
Done installing documentation for nokogiri after 10 seconds
1 gem installed
```

É tudo!

# yamldiff

Na realidade, trata-se do fork [alexandre-mbm/yamldiff](/alexandre-mbm/yamldiff), versão 0.0.10. Ele contém a busca por coincidências entre dois arquivos YAML.

Note que a instalação dar-se-á como feito com o transifex-ruby, nossa primeira dependência.

1) Clonar o repositório GitHub da dependência

```console
$ git clone https://github.com/alexandre-mbm/yamldiff.git
Cloning into 'yamldiff'...
remote: Counting objects: 192, done.
remote: Compressing objects: 100% (109/109), done.
remote: Total 192 (delta 63), reused 192 (delta 63)
Receiving objects: 100% (192/192), 22.54 KiB | 0 bytes/s, done.
Resolving deltas: 100% (63/63), done.
Checking connectivity... done.

$ cd yamldiff
```

2) [Gerar](http://guides.rubygems.org/make-your-own-gem/) o gem da dependência

Primeiro, empacotando as dependências indiretas:

```console
$ bundle
DL is deprecated, please use Fiddle
Your Gemfile lists the gem rspec (>= 0) more than once.
You should probably keep only one of them.
While it's not a problem now, it could cause errors if you change the version of just one of them later.
Your Gemfile lists the gem fakefs (>= 0) more than once.
You should probably keep only one of them.
While it's not a problem now, it could cause errors if you change the version of just one of them later.
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Installing rake 10.4.2
Installing diff-lcs 1.2.5
Using diffy 3.0.7
Installing fakefs 0.6.5
Installing metaclass 0.0.4
Installing mocha 1.1.0
Installing rspec-support 3.2.1
Installing rspec-core 3.2.0
Installing rspec-expectations 3.2.0
Installing rspec-mocks 3.2.0
Installing rspec 3.2.0
Using yamldiff 0.0.10 from source at .
Using bundler 1.7.7
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

Em seguida, usando aquele pacote para criar o gem:

```console
$ gem build yamldiff.gemspec
WARNING:  licenses is empty, but is recommended.  Use a license abbreviation from:
http://opensource.org/licenses/alphabetical
WARNING:  no homepage specified
WARNING:  open-ended dependency on diffy (>= 0) is not recommended
  if diffy is semantically versioned, use:
    add_runtime_dependency 'diffy', '~> 0'
WARNING:  open-ended dependency on fakefs (>= 0, development) is not recommended
  if fakefs is semantically versioned, use:
    add_development_dependency 'fakefs', '~> 0'
WARNING:  open-ended dependency on rake (>= 0, development) is not recommended
  if rake is semantically versioned, use:
    add_development_dependency 'rake', '~> 0'
WARNING:  open-ended dependency on rspec (>= 0, development) is not recommended
  if rspec is semantically versioned, use:
    add_development_dependency 'rspec', '~> 0'
WARNING:  See http://guides.rubygems.org/specification-reference/ for help
  Successfully built RubyGem
  Name: yamldiff
  Version: 0.0.10
  File: yamldiff-0.0.10.gem
```

3) Instalar a dependência: `gem install yamldiff-0.0.10.gem`

``` console
$ gem install yamldiff-0.0.10.gem
Successfully installed yamldiff-0.0.10
Parsing documentation for yamldiff-0.0.10
Installing ri documentation for yamldiff-0.0.10
Done installing documentation for yamldiff after 0 seconds
1 gem installed
```

Pronto!

