class DockerMachineNfs < Formula
  desc "Activates NFS on docker-machine"
  homepage "https://github.com/adlogix/docker-machine-nfs"
  url "https://raw.githubusercontent.com/adlogix/docker-machine-nfs/0.1.0/docker-machine-nfs.sh"
  version "0.1.0"
  sha256 "f7c1742d4644353bb1eb2c2ac4798fd037f7848129ae5e3add1630071521895d"

  def install
    mv "docker-machine-nfs.sh", "docker-machine-nfs"
    bin.install "docker-machine-nfs"
  end

  test do
    system "#{bin}/docker-machine-nfs"
  end
end
