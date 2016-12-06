require 'formula'

class Ionice < Formula
  homepage 'https://github.com/elmarb/ionice'
  url 'https://github.com/elmarb/ionice.git', :revision => '63539195ba6aa082376a53b09a47b33c25a9b204'
  sha1 '03effb6c344a04c9fea2f995ceb4fc8fa270d310'
  version '20120202'

  # Further info available at
  #  https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man3/setiopolicy_np.3.html

  def install
      system "#{ENV.cc} #{ENV.cflags} -o ionice ionice.c"
      bin.install 'ionice'
  end

  test do
    system "#{bin}/ionice"
  end
end
