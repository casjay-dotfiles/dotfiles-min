if [ -f /usr/share/perl5/vendor_perl/Net/XMPP/Debug.pm ]; then
patch -p0 /usr/share/perl5/vendor_perl/Net/XMPP/Debug.pm < sendxmpp.patch
fi
