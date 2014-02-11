require "utils/json"

GitHub.open("https://api.github.com/search/repositories?q=homebrew+in:name&sort=stars&per_page=100") do |json|
  json["items"].each do |repo|
    if repo["name"] =~ /^homebrew-(\S+)$/
      user = repo["owner"]["login"]
      user = user.downcase if user == "Homebrew"
      puts "#{user}/#{$1}"
    end
  end
end
