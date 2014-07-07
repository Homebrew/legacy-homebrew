require 'open-uri'
require 'resource'
require 'formula'

dict_url    = "http://ftpmirror.gnu.org/aspell/dict"
dict_mirror = "http://ftp.gnu.org/gnu/aspell/dict"
languages   = {}

open("#{dict_url}/0index.html") do |content|
  content.each_line do |line|
    break if %r{^</table} === line
    next unless /^<tr><td><a/ === line

    fields = line.split('"')
    lang, path = fields[1], fields[3]
    lang.gsub!("-", "_")
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
    resource "#{r.name}" do
      url "#{r.url}"
      mirror "#{r.mirrors.first}"
      sha1 "#{r.cached_download.sha1}"
    end

  EOS
end
