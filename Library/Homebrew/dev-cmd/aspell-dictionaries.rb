require "open-uri"
require "resource"
require "formula"

module Homebrew
  def aspell_dictionaries
    dict_url    = "http://ftpmirror.gnu.org/aspell/dict"
    dict_mirror = "https://ftp.gnu.org/gnu/aspell/dict"
    languages   = {}

    open("#{dict_url}/0index.html") do |content|
      content.each_line do |line|
        break if %r{^</table} === line
        next unless /^<tr><td><a/ === line

        fields = line.split('"')
        lang = fields[1]
        path = fields[3]
        lang.tr!("-", "_")
        languages[lang] = path
      end
    end

    languages.inject([]) do |resources, (lang, path)|
      r = Resource.new(lang)
      r.owner = Formulary.factory("aspell")
      r.url "#{dict_url}/#{path}"
      r.mirror "#{dict_mirror}/#{path}"
      resources << r
    end.each(&:fetch).each do |r|
      puts <<-EOS
        option "with-lang-#{r.name}", "Install #{r.name} dictionary"
        resource "#{r.name}" do
          url "#{r.url}"
          mirror "#{r.mirrors.first}"
          sha256 "#{r.cached_download.sha256}"
        end

      EOS
    end
  end
end
