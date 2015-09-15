module TVDB
  class Client
    attr_reader :base_uri, :base_with_key, :zip_uri, :banner_uri
    attr_accessor :options

    def initialize(options = {})
      @base_uri = TVDB.xml_mirror(key: false)
      @base_with_key = TVDB.xml_mirror
      @zip_uri = TVDB.zip_mirror
      @banner_uri = TVDB.banner_mirror
      @options ||= options
    end

    def search_series(search_query, opts = {})
      opts.merge!(query: { seriesname: search_query })
      _get('GetSeries.php', opts)['Data']['Series']
    end

    def series_base_info(series_id, opts = {})
      opts[:language] ||= 'en'
      _get_zip(series_id, opts)
      _extract_zip(series_id)
    end

    def banner(file_path)
      HTTParty.get("#{banner_uri}/#{file_path}")
    end

    private

    def _get(resource, opts = {})
      HTTParty.get("#{base_uri}/#{resource}", opts)
    end

    def _get_zip(series_id, opts = {})
      lang ||= opts[:language] || opts[:lang] || 'en'
      File.open("tmp/series-info-#{series_id}.zip", 'wb') do |f|
        f.binmode
        f.write HTTParty.get("#{zip_uri}/series/#{series_id}/all/#{lang}.zip")
      end
    end

    def _extract_zip(series_id)
      ret = {}
      Zip::File.open("tmp/series-info-#{series_id}.zip") do |f|
        f.each do |entry|
          _read_zip(entry, ret)
        end
      end
      ret
    end

    def _read_zip(entry, return_hash)
      TVDB.logger.info("Reading #{entry}")
      content = entry.get_input_stream.read
      base_name = entry.to_s.split('.').first.to_sym
      return_hash[base_name] = (MultiXml.parse(content))
    end
  end
end
