require 'open-uri'
require 'vendor/multi_json'


begin
  puts 'Official taps:'
  open "https://api.github.com/orgs/Homebrew/repos" do |f|
    MultiJson.decode(f.read).each do |repo|
      name = (repo['name'] =~ /^homebrew-(\S+)$/) ? $1 : repo['name']
      puts "\thomebrew/" + name + '  --  "' + repo['description'] + '"'
    end
  end
rescue
  nil
end

puts 'Direct forks of adamv/homebrew-alt:'
# For using github's pagination API
page = 0
# Counter printed at the in front of each line
counter = 0
begin
  page += 1
  hasmore = false
  # http://developer.github.com/v3/repos/forks/
  open "https://api.github.com/repos/adamv/homebrew-alt/forks?sort=watchers&per_page=10&page=#{page}" do |f|
    MultiJson.decode(f.read).each do |repo|
      hasmore = true  # --> while statement at the end
      counter += 1
      # Eleminate "homebrew-" from the repo name
      name = (repo['name'] =~ /^homebrew-(\S+)$/) ? $1 : repo['name']
      descr = ''
      # Avoid the default to be repeated and show only customized descr.
      if repo['description'] != 'Alternate formulae repos for Homebrew'
        descr = '  --  "' + repo['description']+'"'
      end
      puts "#{counter}\t" + repo['owner']['login'] + '/' + name + descr
    end
  end
rescue
  nil
end while hasmore # next page
