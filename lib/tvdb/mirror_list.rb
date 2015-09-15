module TVDB
  class MirrorList
    attr_accessor :xml, :banner, :zip

    def initialize(raw_mirrors)
      @xml = []
      @banner = []
      @zip = []
      raw_mirrors['Mirrors'].each do |_, mirror_info|
        _add_mirror(mirror_info)
      end
    end

    private

    def _add_mirror(mirror_info)
      typemask = mirror_info['typemask']
      xml << mirror_info['mirrorpath'] if _xml?(typemask)
      banner << mirror_info['mirrorpath'] if _banner?(typemask)
      zip << mirror_info['mirrorpath'] if _zip?(typemask)
    end

    def _xml?(typemask)
      TVDB.typemasks[:xml].include? typemask
    end

    def _banner?(typemask)
      TVDB.typemasks[:banner].include? typemask
    end

    def _zip?(typemask)
      TVDB.typemasks[:zip].include? typemask
    end
  end
end
