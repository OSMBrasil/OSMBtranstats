Como estudo de caso, o primeiro autor do script resolveu usar Ruby e Git no Windows, através do console MSYS2. Mas nesta página somente é abordado o que se refere às dependências Ruby do OSMBtranstats.

A única dependência que precisa ser instalada como extra é o **[transifex-ruby](https://github.com/tmaesaka/transifex-ruby)**. O código dele está no GitHub. Como inicialmente o projeto  OSMBtranstats não resulta num gem, o mais prático é (1) clonar o repositório, (2) gerar manualmente o gem daquela dependência e (3) instalá-la.

1) Clonar o repositório GitHub da dependência

````console
$ git clone https://github.com/tmaesaka/transifex-ruby.git
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

Alan@ALAN-NOTEBOOK MSYS /c/Alexandre/Git/GitHub/OSMBtranstats
$ gem install settingslogic
Successfully installed settingslogic-2.0.9
Parsing documentation for settingslogic-2.0.9
Installing ri documentation for settingslogic-2.0.9
Done installing documentation for settingslogic after 1 seconds
1 gem installed
```
Agora ficou entendido que o transifex-ruby precisava instalar quatro dependências: multipart-pos, faraday, faraday_middleware, hashie. Isso foi feito automaticamente, a partir da Internet!