require 'formula'

class GitMergeChangelog < Formula
  head 'http://git.savannah.gnu.org/r/gnulib.git', :using => :git
  homepage 'http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob;f=lib/git-merge-changelog.c'

  def install
    system "./gnulib-tool", "--create-testdir", "--dir=hi", "git-merge-changelog"
    cd "hi" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  def caveats; <<-EOF
-- You have to run this for first use

% cat >> ~/.gitconfig
[merge "merge-changelog"]
name = GNU-style ChangeLog merge driver
driver = #{prefix}/bin/git-merge-changelog %O %A %B
%

-- You have to run this each git repos

% echo "ChangeLog merge=merge-changelog" >> path/to/repo/.git/info/attributes
    EOF
  end

end
