class MediawikiDecorator
    def MediawikiDecorator.factory item
        case item[:type]
            when :transifex
                Transifex_MediawikiDecorator.new item
            when :launchpad
                Launchpad_MediawikiDecorator.new item
            when :taginfo
                Taginfo_MediawikiDecorator.new item, language: 'Pt-br'  # or pt-br
            when :translatewiki
                Translatewiki_MediawikiDecorator.new item, language: 'pt-br'
            when :weblate
                Weblate_MediawikiDecorator.new item, language: 'pt'
            when :github_yaml
                Github_MediawikiDecorator.new item
            else
                MediawikiDecorator.new nil
        end
    end
    def url_template
        '%{project} %{language}'  # never use this, extend it
    end
    def initialize(item, url: nil, language: 'pt_BR')
        unless item == nil
            if item[:language] == nil
                item[:language] = language
            end
            @item = item
            @url = url_template % item
        else
            @item = {}
            @url = url
        end      
    end
    def decorate_message(msg)
        if @url != nil
            '[' + @url + ' ' + msg + ']'
        else
            msg
        end
    end
end

# https://translations.launchpad.net/keepright/trunk/+pots/keepright/pt_BR/+details
# https://translations.launchpad.net/keepright/trunk/+pots/keepright/pt_BR/+translate
class Launchpad_MediawikiDecorator < MediawikiDecorator
    def url_template
        if @item[:resource] == nil
            'https://translations.launchpad.net/%{project}/trunk/+pots/%{project}/%{language}/+translate'
        else
            'https://translations.launchpad.net/%{project}/trunk/+pots/%{resource}/%{language}/+translate'
        end
    end
end

# https://hosted.weblate.org/projects/osmand/main
# https://hosted.weblate.org/projects/osmand/main/pt/translate/?type=untranslated
class Weblate_MediawikiDecorator < MediawikiDecorator
    def url_template
        'https://hosted.weblate.org/projects/%{project}/%{resource}/%{language}/translate/?type=untranslated'
    end
end

# https://translatewiki.net/w/i.php?title=Special:Translate&action=proofread&group=out-osm-site&language=pt-br&filter=translated
class Translatewiki_MediawikiDecorator < MediawikiDecorator
    def url_template
        'https://translatewiki.net/w/i.php?title=Special:Translate&action=proofread&group=%{project}&language=%{language}&filter=translated'
    end
end

class Transifex_MediawikiDecorator < MediawikiDecorator
    def url_template
        if @item[:resource] == nil
            'https://www.transifex.com/projects/p/%{project}/language/%{language}/'
        else
            'https://www.transifex.com/projects/p/%{project}/viewstrings/#%{language}/%{resource}'
        end
    end
end

class Github_MediawikiDecorator < MediawikiDecorator
    def url_template
        'https://github.com/%{project}/blob/master/%{resource_dest}'
    end
end


# http://stackoverflow.com/a/1251199

class SuperProxy
  def initialize(obj)
    @obj = obj
  end

  def method_missing(meth, *args, &blk)
    @obj.class.superclass.instance_method(meth).bind(@obj).call(*args, &blk)
  end
end

class Object
  private
  def sup
    SuperProxy.new(self)
  end
end

class Taginfo_MediawikiDecorator < MediawikiDecorator
    def url_template; '' end
    def decorate_message(msg)
        for_keys = 'http://wiki.openstreetmap.org/wiki/Category:%{language}_key_descriptions'
        for_tags = 'http://wiki.openstreetmap.org/wiki/Category:%{language}_tag_descriptions'
        # 'keys 11.21% / tags 1.42%'
        part = msg.split
        @url = for_keys % @item
        for_keys = sup.decorate_message part[1]
        @url = for_tags % @item
        for_tags = sup.decorate_message part[4]
        '%s %s %s %s %s' % [part[0], for_keys, part[2], part[3], for_tags]
    end
end


if caller.length == 0
    item = { :project => 'taginfo.openstreetmap.org' }
    decorator = Taginfo_MediawikiDecorator.new item, language: 'Pt-br'
    puts decorator.decorate_message 'keys 11.21% / tags 1.42%'
    exit
end

if caller.length == 0
    item = { :project => 'out-osm-site' }
    decorator = MediawikiDecorator.new item, language: 'pt-br'
    puts decorator.decorate_message '100%'
    #exit
end

if caller.length == 0
    item = { :project => 'out-osm-site' }
    decorator = Translatewiki_MediawikiDecorator.new item, language: 'pt-br'
    puts decorator.decorate_message '100%'
    #exit
end

if caller.length == 0
    item = { :project => 'osmand', :resource => 'main' }
    decorator = Weblate_MediawikiDecorator.new item, language: 'pt'
    puts decorator.decorate_message '100%'
    #exit
end

if caller.length == 0
    item = { :project => 'keepright', :resource => 'keepright' }
    decorator = Launchpad_MediawikiDecorator.new item
    puts decorator.decorate_message '100%'
    exit
end
