class LmdbAT0936 < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://github.com/LMDB/lmdb"
  url "https://github.com/LMDB/lmdb/archive/refs/tags/LMDB_0.9.36.tar.gz"
  sha256 "7d55c3cbc1ef55f9b0076d3ddb16d0d9996d05b9caa7ca889ce10430ac677b90"
  license "OLDAP-2.8"
  version_scheme 1

  depends_on "pkgconf" => :test

  def install
    cd "libraries/liblmdb" do
      args = []
      args << "SOEXT=.dylib" if OS.mac?
      system "make", *args
      system "make", "install", *args, "prefix=#{prefix}"
    end

    (lib/"pkgconfig/lmdb.pc").write pc_file
    (lib/"pkgconfig").install_symlink "lmdb.pc" => "liblmdb.pc"
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=${prefix}/lib
      includedir=${prefix}/include

      Name: lmdb
      Description: #{desc}
      URL: #{homepage}
      Version: #{version}
      Libs: -L${libdir} -llmdb
      Cflags: -I${includedir}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")

    # Make sure our `lmdb.pc` can be read by `pkg-config`.
    system "pkg-config", "lmdb"
  end
end
