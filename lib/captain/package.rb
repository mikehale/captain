require 'set'

module Captain
  class Package
    attr_reader :codename
    attr_reader :component
    attr_reader :dependencies
    attr_reader :filename
    attr_reader :md5sum
    attr_reader :mirror
    attr_reader :name
    attr_reader :tasks

    def initialize(mirror, codename, component, manifest)
      @mirror       = mirror
      @codename     = codename
      @component    = component
      @manifest     = manifest

      @dependencies = Set.new
      @provides     = Set.new
      @recommends   = Set.new
      @tasks        = Set.new

      @manifest.each_line do |line|
        case line
        when /^Depends:(.*)$/
          @dependencies.merge(parse_list($1))
        when /^Filename:(.*)$/
          @filename = $1.strip
        when /^MD5sum:(.*)$/
          @md5sum = $1.strip
        when /^Package:(.*)$/
          @name = $1.strip
        when /^Recommends:(.*)$/
          @recommends.merge(parse_list($1))
        when /^Task:(.*)$/
          @tasks.merge(parse_list($1))
        end
      end
    end

    def copy_to(directory)
      Remote.package_file(mirror, filename, md5sum).copy_to(directory, filename)
    end

    def copy_manifest_to(stream)
      # Just making sure we don't end up with extra newlines. Postel's law and all that.
      stream.puts(@manifest.strip)
      stream.puts
    end

    private

    def parse_list(string)
      string.split(/[,|]/).map { |versioned| versioned.strip.split(' ').first }
    end
  end
end
