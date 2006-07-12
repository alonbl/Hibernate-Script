Name: hibernate
Version: 1.92
Release: 1
License: GPL
Group: Applications/System
URL: http://dagobah.ucc.asn.au/swsusp/script2/hibernate-script-1.92.tar.gz
Source0: hibernate-script-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-root
Summary: activates your computer's suspend functionality

%description

This package provides a way to activate the suspend functionality in
the kernel.  Currently it supports anything using the /sys/power/state
interface (including ACPI suspend and the in-kernel software
suspend), as well as Software Suspend 2 (which is available as a
separate kernel patch from www.suspend2.net).

Hibernate can take care of loading and unloading modules, various
hacks needed to get some video cards to resume properly under X,
restarting networking and system services.  It can be extended by
writing new "scriplets" which run at different parts of the suspend
process.

After installing you will want to run 'hibernate -h' to see available
options and modify your /etc/hibernate/hibernate.conf to set them. 

%prep
mkdir -p ${RPM_BUILD_ROOT}/usr/share/doc/hibernate-%version-%release

%setup -n hibernate-script-%version

%install
export BASE_DIR=${RPM_BUILD_ROOT}
export PREFIX=/usr
sh install.sh

%clean
unset BASE_DIR
unset PREFIX
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)

# Directories owned by this package
%dir /usr/share/hibernate

# Files owned by this package (taken from %{buildroot}
/usr/sbin/hibernate
/usr/share/hibernate/*
/usr/man/*
%config /etc/hibernate/*

# Documentation for this package (taken from $RPM_BUILD_DIR)
%doc CHANGELOG
%doc COPYING
%doc README
%doc SCRIPTLET-API

%changelog
* Mon Jul 12 2006 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.92 final version
* Mon Jun  5 2006 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.91 final version
* Mon Jun  5 2006 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.90 final version
* Sun Oct  2 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.12 final version
* Sun Oct  2 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.11 final version
* Wed Jul 13 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.10 final version
* Fri Jun 27 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.09 final version
* Fri May 13 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.08 final version
* Thu Apr 21 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.07 final version
* Thu Mar 31 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.06 final version
* Wed Feb  9 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.05 final version
* Tue Feb  8 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.04 final version
* Wed Jan  5 2005 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.03 final version
* Wed Nov 24 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.02 final version
* Thu Nov 18 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.01 final version
* Sun Nov  7 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 1.00 final version
* Fri Aug 20 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 0.99 final version
* Fri Aug 20 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 0.98 final version
* Thu Jul 29 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 0.97 final version
* Sat Jul 24 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 0.96 final version
* Sat Jul 24 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 0.96-rc2 version
* Sat Jul 24 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 0.96-rc1 version
* Fri Jul 23 2004 Bernard Blackham <bernard@blackham.com.au> -
- Updated to 0.95.1 final version
* Wed Jul 21 2004 Kevin Fenzi <kevin@tummy.com> -
- Updated to 0.95 final version
* Fri Jul 16 2004 Kevin Fenzi <kevin@tummy.com> -
- Updated to 0.95-rc1 version
* Mon Jul 12 2004 Kevin Fenzi <kevin@tummy.com> - 
- Initial build.
