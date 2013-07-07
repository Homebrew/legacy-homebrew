require 'utils/json'

GitHub.open "https://api.github.com/legacy/repos/search/homebrew" do |f|
  Utils::JSON.load(f.read)["repositories"].each do |repo|
    if repo['name'] =~ /^homebrew-(\S+)$/
      puts tap = if repo['username'] == "Homebrew"
        "homebrew/#{$1}"
      else
        repo['username']+"/"+$1
      end
    end
  end
end
