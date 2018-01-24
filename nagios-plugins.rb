class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz"
  sha256 "4355b5daede0fa72bbb55d805d724dfa3d05e7f66592ad71b4e047c6d9cdd090"

  bottle do
    sha256 "33f3ad7bc229a5c98a91f1dc60fc5e113afdccb63e3e0c824c631062403c91ac" => :sierra
    sha256 "8a45819e58f06a9cea8f34d2f13d79c22a73ea6fa77eef231681127b6227185a" => :el_capitan
    sha256 "1cf4050b3043c6f74ccadb02ccdfe7b438994bfafad3758eafe625a7539c19db" => :yosemite
  end

  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional

  patch :p0, :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
    system "make", "install-root"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<-EOS.undent
    All plugins have been installed in:
      #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H 8.8.8.8 -t 3")
    assert_match "google-public-dns", output
  end
end

__END__
--- plugins-root/Makefile.in.orig	2017-02-07 09:09:42.000000000 +0100
+++ plugins-root/Makefile.in	2017-02-07 14:45:39.000000000 +0100
@@ -1315,7 +1315,6 @@
 NETLIBS = $(NETOBJS) $(SOCKETLIBS)
 TESTS_ENVIRONMENT = perl -I $(top_builddir) -I $(top_srcdir)
 TESTS = @PLUGIN_TEST@
-setuid_root_mode = ug=rx,u+s

 # /* Author Coreutils team - see ACKNOWLEDGEMENTS */
 INSTALL_SUID = \
@@ -1323,10 +1322,6 @@
 	p=$$f; \
 	echo " $(INSTALL_PROGRAM) $$p $(DESTDIR)$(libexecdir)/$$p"; \
 	$(INSTALL_PROGRAM) $$p $(DESTDIR)$(libexecdir)/$$p; \
-	echo " chown root $(DESTDIR)$(libexecdir)/$$p"; \
-	chown root $(DESTDIR)$(libexecdir)/$$p; \
-	echo " chmod $(setuid_root_mode) $(DESTDIR)$(libexecdir)/$$p"; \
-	chmod $(setuid_root_mode) $(DESTDIR)$(libexecdir)/$$p; \
 	done


@@ -1751,20 +1746,7 @@
 	@$(INSTALL_SUID)

 install-exec-local: $(noinst_PROGRAMS)
-	@TMPFILE=$(DESTDIR)$(libexecdir)/.setuid-$$$$; \
-	rm -f $$TMPFILE; \
-	echo > $$TMPFILE; \
-	can_create_suid_root_executable=no; \
-	chown root $$TMPFILE > /dev/null 2>&1 \
-	  && chmod $(setuid_root_mode) $$TMPFILE > /dev/null 2>&1 \
-	  && can_create_suid_root_executable=yes; \
-	rm -f $$TMPFILE; \
-	if test $$can_create_suid_root_executable = yes; then \
-	  $(INSTALL_SUID); \
-	else \
-	  echo "WARNING: insufficient access; not installing setuid plugins"; \
-	  echo "NOTE: to install setuid plugins, run 'make install-root' as root"; \
-	fi
+	@$(INSTALL_SUID)

 clean-local:
 	rm -f NP-VERSION-FILE
