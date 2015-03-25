module ESPN
  class Cache
    class << self
      def fetch(cache_key, attrs = {}, &block)
        keys << cache_key

        client.fetch(cache_key, attrs, &block)
      end

      def precache
        ESPN::Schedule.precache
      end

      def read(cache_key)
        client.read(cache_key)
      end

      def write(cache_key, data, attrs = {})
        client.write(cache_key, data, attrs)
      end

      def client
        @@client ||= DefaultCacheStore.new
      end

      def client=(client)
        @@client = client
      end

      def keys
        @@keys ||= []
      end

      def purge
        keys.each do |key|
          client.clear(key)
          keys.delete key
        end
      end
    end
  end

  class DefaultCacheStore
    attr_accessor :cache

    def initialize
      self.cache = {}
    end

    def fetch(cache_key, attrs, &block)
      return read(cache_key) if read(cache_key)

      write(cache_key, yield)

      return read(cache_key)
    end

    def read(cache_key)
      self.cache[cache_key]
    end

    def write(cache_key, data, attrs = {})
      self.cache[cache_key] = data
    end

    def clear(key)
      self.cache.delete key
    end
  end
end
