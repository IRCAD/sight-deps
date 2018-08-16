# Makefile for libxml2, specific for Windows, MSVC and NMAKE.
#
# Take a look at the beginning and modify the variables to suit your 
# environment. Having done that, you can do a
#
# nmake [all]     to build the libxml and the accompanying utilities.
# nmake clean     to remove all compiler output files and return to a
#                 clean state.
# nmake rebuild   to rebuild everything from scratch. This basically does
#                 a 'nmake clean' and then a 'nmake all'.
# nmake install   to install the library and its header files.
#
# March 2002, Igor Zlatkovic <igor@zlatkovic.com>

# There should never be a need to modify anything below this line.
# ----------------------------------------------------------------

AUTOCONF = .\config.msvc
!include $(AUTOCONF)
PREFIX=@LIBXML_INSTALL_DIR_WIN32@
BINPREFIX=$(PREFIX)\bin
INCPREFIX=$(PREFIX)\include
LIBPREFIX=$(PREFIX)\lib
SOPREFIX=$(PREFIX)\bin
# Names of various input and output components.
XML_NAME = xml2
XML_BASENAME = lib$(XML_NAME)
XML_SO = $(XML_BASENAME).dll
XML_IMP = $(XML_BASENAME).lib
XML_DEF = $(XML_BASENAME).def
XML_A = $(XML_BASENAME)_a.lib
XML_A_DLL = $(XML_BASENAME)_a_dll.lib

# Place where we let the compiler put its output.
BINDIR = bin.msvc
XML_INTDIR = int.msvc
XML_INTDIR_A = int.a.msvc
XML_INTDIR_A_DLL = int.a.dll.msvc
UTILS_INTDIR = int.utils.msvc

# The preprocessor and its options.
CPP = cl.exe /EP
CPPFLAGS = /nologo /I$(XML_SRCDIR)\include /D "NOLIBTOOL" 
!if "$(WITH_THREADS)" != "no"
CPPFLAGS = $(CPPFLAGS) /D "_REENTRANT"
!endif

# The compiler and its options.
CC = cl.exe
CFLAGS = /nologo /D "WIN32" /D "_WINDOWS" /D "_MBCS" /D "HAVE_CONFIG_H" /D "NOLIBTOOL" /W1 $(CRUNTIME)
CFLAGS = $(CFLAGS) /I$(XML_SRCDIR) /I$(XML_SRCDIR)\include /I$(INCPREFIX)
!if "$(WITH_THREADS)" != "no"
CFLAGS = $(CFLAGS) /D "_REENTRANT"
!endif
!if "$(WITH_THREADS)" == "yes" || "$(WITH_THREADS)" == "ctls"
CFLAGS = $(CFLAGS) /D "HAVE_WIN32_THREADS" /D "HAVE_COMPILER_TLS"
!else if "$(WITH_THREADS)" == "native"
CFLAGS = $(CFLAGS) /D "HAVE_WIN32_THREADS"
!else if "$(WITH_THREADS)" == "posix"
CFLAGS = $(CFLAGS) /D "HAVE_PTHREAD_H"
!endif
!if "$(WITH_ZLIB)" == "1"
CFLAGS = $(CFLAGS) /D "HAVE_ZLIB_H"
!endif
!if "$(WITH_LZMA)" == "1"
CFLAGS = $(CFLAGS) /D "HAVE_LZMA_H"
!endif
CFLAGS = $(CFLAGS) /D_CRT_SECURE_NO_DEPRECATE /D_CRT_NONSTDC_NO_DEPRECATE

# The linker and its options.
LD = link.exe
LDFLAGS = /nologo /VERSION:$(LIBXML_MAJOR_VERSION).$(LIBXML_MINOR_VERSION)
LDFLAGS = $(LDFLAGS) /LIBPATH:$(BINDIR) /LIBPATH:$(LIBPREFIX)
LIBS =
!if "$(WITH_FTP)" == "1" || "$(WITH_HTTP)" == "1"
LIBS = $(LIBS) wsock32.lib ws2_32.lib
!endif 
!if "$(WITH_ICONV)" == "1"
LIBS = $(LIBS) iconv.lib
!endif 
!if "$(WITH_ICU)" == "1"
LIBS = $(LIBS) icu.lib
!endif
!if "$(WITH_ZLIB)" == "1"
LIBS = $(LIBS) zdll.lib
!endif
!if "$(WITH_LZMA)" == "1"
LIBS = $(LIBS) liblzma.lib
!endif
!if "$(WITH_THREADS)" == "posix"
LIBS = $(LIBS) pthreadVC.lib
!endif
!if "$(WITH_MODULES)" == "1"
LIBS = $(LIBS) kernel32.lib
!endif

# The archiver and its options.
AR = lib.exe
ARFLAGS = /nologo

# Optimisation and debug symbols.
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS) /D "_DEBUG" /Od /Z7
LDFLAGS = $(LDFLAGS) /DEBUG
!else
CFLAGS = $(CFLAGS) /D "NDEBUG" /O2 
# commented out as this break VC10 c.f. 634846
# LDFLAGS = $(LDFLAGS) /OPT:NOWIN98
LDFLAGS = $(LDFLAGS)
!endif

# Libxml object files.
XML_OBJS = $(XML_INTDIR)\buf.obj\
	$(XML_INTDIR)\c14n.obj\
	$(XML_INTDIR)\catalog.obj\
	$(XML_INTDIR)\chvalid.obj\
	$(XML_INTDIR)\debugXML.obj\
	$(XML_INTDIR)\dict.obj\
	$(XML_INTDIR)\DOCBparser.obj\
	$(XML_INTDIR)\encoding.obj\
	$(XML_INTDIR)\entities.obj\
	$(XML_INTDIR)\error.obj\
	$(XML_INTDIR)\globals.obj\
	$(XML_INTDIR)\hash.obj\
	$(XML_INTDIR)\HTMLparser.obj\
	$(XML_INTDIR)\HTMLtree.obj\
	$(XML_INTDIR)\legacy.obj\
	$(XML_INTDIR)\list.obj\
	$(XML_INTDIR)\nanoftp.obj\
	$(XML_INTDIR)\nanohttp.obj\
	$(XML_INTDIR)\parser.obj\
	$(XML_INTDIR)\parserInternals.obj\
	$(XML_INTDIR)\pattern.obj\
	$(XML_INTDIR)\relaxng.obj\
	$(XML_INTDIR)\SAX2.obj\
	$(XML_INTDIR)\SAX.obj\
	$(XML_INTDIR)\schematron.obj\
	$(XML_INTDIR)\threads.obj\
	$(XML_INTDIR)\tree.obj\
	$(XML_INTDIR)\uri.obj\
	$(XML_INTDIR)\valid.obj\
	$(XML_INTDIR)\xinclude.obj\
	$(XML_INTDIR)\xlink.obj\
	$(XML_INTDIR)\xmlIO.obj\
	$(XML_INTDIR)\xmlmemory.obj\
	$(XML_INTDIR)\xmlreader.obj\
	$(XML_INTDIR)\xmlregexp.obj\
	$(XML_INTDIR)\xmlmodule.obj\
	$(XML_INTDIR)\xmlsave.obj\
	$(XML_INTDIR)\xmlschemas.obj\
	$(XML_INTDIR)\xmlschemastypes.obj\
	$(XML_INTDIR)\xmlunicode.obj\
	$(XML_INTDIR)\xmlwriter.obj\
	$(XML_INTDIR)\xpath.obj\
	$(XML_INTDIR)\xpointer.obj\
	$(XML_INTDIR)\xmlstring.obj

# Static libxml object files.
XML_OBJS_A = $(XML_INTDIR_A)\buf.obj\
	$(XML_INTDIR_A)\c14n.obj\
	$(XML_INTDIR_A)\catalog.obj\
	$(XML_INTDIR_A)\chvalid.obj\
	$(XML_INTDIR_A)\debugXML.obj\
	$(XML_INTDIR_A)\dict.obj\
	$(XML_INTDIR_A)\DOCBparser.obj\
	$(XML_INTDIR_A)\encoding.obj\
	$(XML_INTDIR_A)\entities.obj\
	$(XML_INTDIR_A)\error.obj\
	$(XML_INTDIR_A)\globals.obj\
	$(XML_INTDIR_A)\hash.obj\
	$(XML_INTDIR_A)\HTMLparser.obj\
	$(XML_INTDIR_A)\HTMLtree.obj\
	$(XML_INTDIR_A)\legacy.obj\
	$(XML_INTDIR_A)\list.obj\
	$(XML_INTDIR_A)\nanoftp.obj\
	$(XML_INTDIR_A)\nanohttp.obj\
	$(XML_INTDIR_A)\parser.obj\
	$(XML_INTDIR_A)\parserInternals.obj\
	$(XML_INTDIR_A)\pattern.obj\
	$(XML_INTDIR_A)\relaxng.obj\
	$(XML_INTDIR_A)\SAX2.obj\
	$(XML_INTDIR_A)\SAX.obj\
	$(XML_INTDIR_A)\schematron.obj\
	$(XML_INTDIR_A)\threads.obj\
	$(XML_INTDIR_A)\tree.obj\
	$(XML_INTDIR_A)\uri.obj\
	$(XML_INTDIR_A)\valid.obj\
	$(XML_INTDIR_A)\xinclude.obj\
	$(XML_INTDIR_A)\xlink.obj\
	$(XML_INTDIR_A)\xmlIO.obj\
	$(XML_INTDIR_A)\xmlmemory.obj\
	$(XML_INTDIR_A)\xmlreader.obj\
	$(XML_INTDIR_A)\xmlregexp.obj\
	$(XML_INTDIR_A)\xmlmodule.obj\
	$(XML_INTDIR_A)\xmlsave.obj\
	$(XML_INTDIR_A)\xmlschemas.obj\
	$(XML_INTDIR_A)\xmlschemastypes.obj\
	$(XML_INTDIR_A)\xmlunicode.obj\
	$(XML_INTDIR_A)\xmlwriter.obj\
	$(XML_INTDIR_A)\xpath.obj\
	$(XML_INTDIR_A)\xpointer.obj\
	$(XML_INTDIR_A)\xmlstring.obj

# Static libxml object files.
XML_OBJS_A_DLL = $(XML_INTDIR_A_DLL)\buf.obj\
	$(XML_INTDIR_A_DLL)\c14n.obj\
	$(XML_INTDIR_A_DLL)\catalog.obj\
	$(XML_INTDIR_A_DLL)\chvalid.obj\
	$(XML_INTDIR_A_DLL)\debugXML.obj\
	$(XML_INTDIR_A_DLL)\dict.obj\
	$(XML_INTDIR_A_DLL)\DOCBparser.obj\
	$(XML_INTDIR_A_DLL)\encoding.obj\
	$(XML_INTDIR_A_DLL)\entities.obj\
	$(XML_INTDIR_A_DLL)\error.obj\
	$(XML_INTDIR_A_DLL)\globals.obj\
	$(XML_INTDIR_A_DLL)\hash.obj\
	$(XML_INTDIR_A_DLL)\HTMLparser.obj\
	$(XML_INTDIR_A_DLL)\HTMLtree.obj\
	$(XML_INTDIR_A_DLL)\legacy.obj\
	$(XML_INTDIR_A_DLL)\list.obj\
	$(XML_INTDIR_A_DLL)\nanoftp.obj\
	$(XML_INTDIR_A_DLL)\nanohttp.obj\
	$(XML_INTDIR_A_DLL)\parser.obj\
	$(XML_INTDIR_A_DLL)\parserInternals.obj\
	$(XML_INTDIR_A_DLL)\pattern.obj\
	$(XML_INTDIR_A_DLL)\relaxng.obj\
	$(XML_INTDIR_A_DLL)\SAX2.obj\
	$(XML_INTDIR_A_DLL)\SAX.obj\
	$(XML_INTDIR_A_DLL)\schematron.obj\
	$(XML_INTDIR_A_DLL)\threads.obj\
	$(XML_INTDIR_A_DLL)\tree.obj\
	$(XML_INTDIR_A_DLL)\uri.obj\
	$(XML_INTDIR_A_DLL)\valid.obj\
	$(XML_INTDIR_A_DLL)\xinclude.obj\
	$(XML_INTDIR_A_DLL)\xlink.obj\
	$(XML_INTDIR_A_DLL)\xmlIO.obj\
	$(XML_INTDIR_A_DLL)\xmlmemory.obj\
	$(XML_INTDIR_A_DLL)\xmlreader.obj\
	$(XML_INTDIR_A_DLL)\xmlregexp.obj\
	$(XML_INTDIR_A_DLL)\xmlmodule.obj\
	$(XML_INTDIR_A_DLL)\xmlsave.obj\
	$(XML_INTDIR_A_DLL)\xmlschemas.obj\
	$(XML_INTDIR_A_DLL)\xmlschemastypes.obj\
	$(XML_INTDIR_A_DLL)\xmlunicode.obj\
	$(XML_INTDIR_A_DLL)\xmlwriter.obj\
	$(XML_INTDIR_A_DLL)\xpath.obj\
	$(XML_INTDIR_A_DLL)\xpointer.obj\
	$(XML_INTDIR_A_DLL)\xmlstring.obj

# Xmllint and friends executables.
UTILS = $(BINDIR)\xmllint.exe\
	$(BINDIR)\xmlcatalog.exe\
	$(BINDIR)\testAutomata.exe\
	$(BINDIR)\testC14N.exe\
	$(BINDIR)\testDocbook.exe\
	$(BINDIR)\testHTML.exe\
	$(BINDIR)\testReader.exe\
	$(BINDIR)\testRelax.exe\
	$(BINDIR)\testRegexp.exe\
	$(BINDIR)\testModule.exe\
	$(BINDIR)\testSAX.exe\
	$(BINDIR)\testSchemas.exe\
	$(BINDIR)\testURI.exe\
	$(BINDIR)\testXPath.exe\
	$(BINDIR)\runtest.exe\
	$(BINDIR)\runsuite.exe\
	$(BINDIR)\testapi.exe\
	$(BINDIR)\testlimits.exe\
	$(BINDIR)\testrecurse.exe
	
!if "$(WITH_THREADS)" == "yes" || "$(WITH_THREADS)" == "ctls" || "$(WITH_THREADS)" == "native"
UTILS = $(UTILS) $(BINDIR)\testThreadsWin32.exe
!else if "$(WITH_THREADS)" == "posix"
UTILS = $(UTILS) $(BINDIR)\testThreads.exe
!endif

!if "$(VCMANIFEST)" == "1"
_VC_MANIFEST_EMBED_EXE= if exist $@.manifest mt.exe -nologo -manifest $@.manifest -outputresource:$@;1
_VC_MANIFEST_EMBED_DLL= if exist $@.manifest mt.exe -nologo -manifest $@.manifest -outputresource:$@;2
!else
_VC_MANIFEST_EMBED_EXE=
_VC_MANIFEST_EMBED_DLL=
!endif

all : libxml libxmla libxmladll utils

libxml : $(BINDIR)\$(XML_SO) 

libxmla : $(BINDIR)\$(XML_A)

libxmladll : $(BINDIR)\$(XML_A_DLL)

utils : $(UTILS)

clean :
	if exist $(XML_INTDIR) rmdir /S /Q $(XML_INTDIR)
	if exist $(XML_INTDIR_A) rmdir /S /Q $(XML_INTDIR_A)
	if exist $(XML_INTDIR_A_DLL) rmdir /S /Q $(XML_INTDIR_A_DLL)
	if exist $(UTILS_INTDIR) rmdir /S /Q $(UTILS_INTDIR)
	if exist $(BINDIR) rmdir /S /Q $(BINDIR)

distclean : clean
	if exist config.* del config.*
	if exist Makefile del Makefile

rebuild : clean all

install-libs : all
	if not exist $(INCPREFIX)\libxml2 mkdir $(INCPREFIX)\libxml2
	if not exist $(INCPREFIX)\libxml2\libxml mkdir $(INCPREFIX)\libxml2\libxml
	if not exist $(BINPREFIX) mkdir $(BINPREFIX)
	if not exist $(LIBPREFIX) mkdir $(LIBPREFIX)
	if not exist $(SOPREFIX) mkdir $(SOPREFIX)
	copy $(XML_SRCDIR)\include\libxml\*.h $(INCPREFIX)\libxml2\libxml
	copy $(BINDIR)\$(XML_SO) $(SOPREFIX)
	copy $(BINDIR)\$(XML_A) $(LIBPREFIX)
	copy $(BINDIR)\$(XML_A_DLL) $(LIBPREFIX)
	copy $(BINDIR)\$(XML_IMP) $(LIBPREFIX)

install : install-libs 
	copy $(BINDIR)\*.exe $(BINPREFIX)
	-copy $(BINDIR)\*.pdb $(BINPREFIX)

install-dist : install-libs 
	copy $(BINDIR)\xml*.exe $(BINPREFIX)
	-copy $(BINDIR)\xml*.pdb $(BINPREFIX)

# This is a target for me, to make a binary distribution. Not for the public use,
# keep your hands off :-)
BDVERSION = $(LIBXML_MAJOR_VERSION).$(LIBXML_MINOR_VERSION).$(LIBXML_MICRO_VERSION)
BDPREFIX = $(XML_BASENAME)-$(BDVERSION).win32
bindist : all
	$(MAKE) /nologo PREFIX=$(BDPREFIX) SOPREFIX=$(BDPREFIX)\bin install-dist
	cscript //NoLogo configure.js genreadme $(XML_BASENAME) $(BDVERSION) $(BDPREFIX)\readme.txt


# Makes the output directory.
$(BINDIR) :
	if not exist $(BINDIR) mkdir $(BINDIR)


# Makes the libxml intermediate directory.
$(XML_INTDIR) :
	if not exist $(XML_INTDIR) mkdir $(XML_INTDIR)

# Makes the static libxml intermediate directory.
$(XML_INTDIR_A) :
	if not exist $(XML_INTDIR_A) mkdir $(XML_INTDIR_A)

# Makes the static for dll libxml intermediate directory.
$(XML_INTDIR_A_DLL) :
	if not exist $(XML_INTDIR_A_DLL) mkdir $(XML_INTDIR_A_DLL)

# An implicit rule for libxml compilation.
{$(XML_SRCDIR)}.c{$(XML_INTDIR)}.obj::
	$(CC) $(CFLAGS) /Fo$(XML_INTDIR)\ /c $<

# An implicit rule for static libxml compilation.
{$(XML_SRCDIR)}.c{$(XML_INTDIR_A)}.obj::
	$(CC) $(CFLAGS) /D "LIBXML_STATIC" /Fo$(XML_INTDIR_A)\ /c $<

# An implicit rule for static for dll libxml compilation.
{$(XML_SRCDIR)}.c{$(XML_INTDIR_A_DLL)}.obj::
	$(CC) $(CFLAGS) /D "LIBXML_STATIC" /D "LIBXML_STATIC_FOR_DLL" /Fo$(XML_INTDIR_A_DLL)\ /c $<

# Compiles libxml source. Uses the implicit rule for commands.
$(XML_OBJS) : $(XML_INTDIR) 

# Compiles static libxml source. Uses the implicit rule for commands.
$(XML_OBJS_A) : $(XML_INTDIR_A) 

# Compiles static for dll libxml source. Uses the implicit rule for commands.
$(XML_OBJS_A_DLL) : $(XML_INTDIR_A_DLL) 

# Creates the export definition file (DEF) for libxml.
$(XML_INTDIR)\$(XML_DEF) : $(XML_INTDIR) $(XML_DEF).src
	$(CPP) $(CPPFLAGS) $(XML_DEF).src > $(XML_INTDIR)\$(XML_DEF)

# Creates the libxml shared object.
$(BINDIR)\$(XML_SO) : $(BINDIR) $(XML_OBJS) $(XML_INTDIR)\$(XML_DEF)
	$(LD) $(LDFLAGS) /DLL \
		/IMPLIB:$(BINDIR)\$(XML_IMP) /OUT:$(BINDIR)\$(XML_SO) $(XML_OBJS) $(LIBS)
	@$(_VC_MANIFEST_EMBED_DLL)

#$(BINDIR)\$(XML_SO) : $(BINDIR) $(XML_OBJS) $(XML_INTDIR)\$(XML_DEF)
#	$(LD) $(LDFLAGS) /DLL /DEF:$(XML_INTDIR)\$(XML_DEF) \
#		/IMPLIB:$(BINDIR)\$(XML_IMP) /OUT:$(BINDIR)\$(XML_SO) $(XML_OBJS) $(LIBS)

# Creates the libxml archive.
$(BINDIR)\$(XML_A) : $(BINDIR) $(XML_OBJS_A)
	$(AR) $(ARFLAGS) /OUT:$(BINDIR)\$(XML_A) $(XML_OBJS_A)

# Creates the libxml static for dll archive.
$(BINDIR)\$(XML_A_DLL) : $(BINDIR) $(XML_OBJS_A_DLL)
	$(AR) $(ARFLAGS) /OUT:$(BINDIR)\$(XML_A_DLL) $(XML_OBJS_A_DLL)

# Makes the utils intermediate directory.
$(UTILS_INTDIR) :
	if not exist $(UTILS_INTDIR) mkdir $(UTILS_INTDIR)

# An implicit rule for xmllint and friends.
!if "$(STATIC)" == "1"
{$(UTILS_SRCDIR)}.c{$(BINDIR)}.exe:
	$(CC) /D "LIBXML_STATIC" $(CFLAGS) /Fo$(UTILS_INTDIR)\ /c $< 
	$(LD) $(LDFLAGS) /OUT:$@ $(XML_A) $(LIBS) $(UTILS_INTDIR)\$(<B).obj
	@$(_VC_MANIFEST_EMBED_EXE)
!else
{$(UTILS_SRCDIR)}.c{$(BINDIR)}.exe:
	$(CC) $(CFLAGS) /Fo$(UTILS_INTDIR)\ /c $< 
	$(LD) $(LDFLAGS) /OUT:$@ $(XML_IMP) $(LIBS) $(UTILS_INTDIR)\$(<B).obj
	@$(_VC_MANIFEST_EMBED_EXE)
!endif

# Builds xmllint and friends. Uses the implicit rule for commands.
$(UTILS) : $(UTILS_INTDIR) $(BINDIR) libxml libxmla libxmladll

# Source dependences should be autogenerated somehow here, but how to
# do it? I have no clue.

# TESTS

tests : checktests XPathtests

checktests : $(UTILS)
	cd .. && win32\$(BINDIR)\runtest.exe
	cd .. && win32\$(BINDIR)\testrecurse.exe
	cd .. && win32\$(BINDIR)\testapi.exe
	cd .. && win32\$(BINDIR)\testchar.exe
	cd .. && win32\$(BINDIR)\testdict.exe
	cd .. && win32\$(BINDIR)\runxmlconf.exe

XPathtests : $(BINDIR)\testXPath.exe
	@echo. 2> .memdump
	@echo ## XPath regression tests
	@-$(BINDIR)\testXPath.exe | find /C "support not compiled in" 1>nul
	@if %ERRORLEVEL% NEQ 0 @( \
		echo Skipping debug not compiled in\
		@exit 0 \
	)
	@for %%I in ($(XML_SRCDIR)\test\XPath\expr\*.*) do @( \
		@IF NOT EXIST $(XML_SRCDIR)\result\XPath\expr\%%~nxI ( \
			@echo New test %%~nxI &&\
			@echo %%~nxI &&\
			$(BINDIR)\testXPath.exe -f --expr %%I > $(XML_SRCDIR)/result/XPath/expr/%%~nxI &&\
			findstr /C:"MEMORY ALLOCATED : 0" \
		) ELSE ( \
			$(BINDIR)\testXPath.exe -f --expr %%I 2>&1 > result.%%~nxI &&\
			fc $(XML_SRCDIR)\result\XPath\expr\%%~nxI result.%%~nxI >nul &\
			iF ERRORLEVEL 1 exit 1 & \
			findstr "MEMORY ALLOCATED" .memdump | findstr /C:"MEMORY ALLOCATED : 0" >nul &&\
			del result.%%~nxI \
		) \
	)
	@for %%I in ($(XML_SRCDIR)\test\XPath\docs\*.*) do @( \
		for %%J in ($(XML_SRCDIR)\test\XPath\tests\%%~nxI*.*) do @( \
			if not exist $(XML_SRCDIR)\result\XPath\tests\%%~nxJ ( \
				$(BINDIR)\testXPath.exe -f -i %%I %%J > $(XML_SRCDIR)\result\XPath\tests\%%~nxJ &&\
				findstr /C:"MEMORY ALLOCATED" .memdump | findstr /C:"MEMORY ALLOCATED : 0" > nul \
			) ELSE ( \
				$(BINDIR)\testXPAth.exe -f -i %%I %%J 2>&1 > result.%%~nxJ &&\
				findstr /C:"MEMORY ALLOCATED" .memdump | findstr /C:"MEMORY ALLOCATED : 0">null &&\
				fc $(XML_SRCDIR)\result\XPath\tests\%%~nxJ result.%%~nxJ >null & \
				IF ERRORLEVEL 1 (echo Error: %%I %%J & exit 1) & \
				del result.%%~nxJ \
			)\
		)\
	)

XMLtests : $(BINDIR)\xmllint.exe
	@echo. 2> .memdump
	@echo ## XML regression tests
	-@for %%I in ($(XML_SRCDIR)\test\*) do @( \
		if not exist $(XML_SRCDIR)\result\%%~nxI ( \
			echo New test file %%~nxI &\
			$(BINDIR)\xmllint.exe  %%I > $(XML_SRCDIR)\result\%%~nxI && \
			findstr /C:"MEMORY ALLOCATED" .memdump | findstr /C:"MEMORY ALLOCATED : 0" > null \
		) ELSE ( \
			$(BINDIR)\xmllint.exe %%I 2>&1 > result.%%~nxI && \
			findstr /C:"MEMORY ALLOC" .memdump | findstr /C:"MEMORY ALLOCATED : 0" > null && \
			fc $(XML_SRCDIR)\result\%%~nxI result.%%~nxI > null && \
			$(BINDIR)\xmllint.exe result.%%~nxI 2>&1 > result2.%%~nxI | findstr /V /C:"failed to load external entity" && \
			fc result.%%~nxI result2.%%~nxI & \
			del result.%%~nxI result2.%%~nxI\
		) \
	)	

				



	
