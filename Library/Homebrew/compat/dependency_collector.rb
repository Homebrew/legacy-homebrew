require "dependency_collector"

class DependencyCollector
  alias_method :_parse_symbol_spec, :parse_symbol_spec

  def parse_symbol_spec(spec, tags)
    case spec
    when :clt
    when :autoconf, :automake, :bsdmake, :libtool
      autotools_dep(spec, tags)
    when :cairo, :fontconfig, :freetype, :libpng, :pixman
      Dependency.new(spec.to_s, tags)
    when :libltdl
      tags << :run
      Dependency.new("libtool", tags)
    else
      _parse_symbol_spec(spec, tags)
    end
  end

  def autotools_dep(spec, tags)
    tags << :build unless tags.include? :run
    Dependency.new(spec.to_s, tags)
  end
end
