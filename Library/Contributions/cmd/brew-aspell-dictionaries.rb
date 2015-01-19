require 'open-uri'
require 'resource'
require 'formula'

dict_url    = "http://ftpmirror.gnu.org/aspell/dict"
dict_mirror = "http://ftp.gnu.org/gnu/aspell/dict"

resources = {}

open("#{dict_url}/0index.html") do |content|
  content.each_line do |line|
    break if %r{^</table} === line
    next unless /^<tr><td><a/ === line

    fields = line.split('"')
    lang, path = fields[1], fields[3]
    lang.gsub!("-", "_")
    resources[lang] = path
  end
end

resources.each_pair do |lang, path|
  r = Resource.new(lang, "#{dict_url}/#{path}")
  r.owner = Formula.factory('aspell')

  nostdout { r.fetch }

  puts <<-EOS
  resource '#{lang}' do
    url '#{dict_url}/#{path}'
    mirror '#{dict_mirror}/#{path}'
    sha1 '#{r.cached_download.sha1}'
  end

EOS
end
