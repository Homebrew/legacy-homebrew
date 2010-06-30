# Updates all outdated brews
# See: http://github.com/mxcl/homebrew/issues/issue/1324

# patch ARGV to use all of the outdated packages as the names passed in
module HomebrewArgvExtension
  def formulae
    @formulae = outdated_brews.map {|_keg, name, _version| Formula.factory name}
  end
end

brew_install
