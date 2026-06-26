%
% Created by Alistair Smith, Sunrise Setting Ltd, 1 February 2011
%
% icst.cls --- For CREATE-NET

\def\update{2011/04/11 v1.11}

\newcommand{\journalnamelc}{EAI Endorsed Transactions}
\newcommand{\journalabb}{EAI Endorsed Transactions}
\newcommand{\journalclass}{icst.cls}
\newcommand{\journalclassshort}{icst}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{icst}[\update\ \journalclass]

%\newcommand\hmmax{0}

\newif\if@doublespace
\DeclareOption{doublespace}{%
\@doublespacetrue}

\newif\if@production
\DeclareOption{production}{%
\@productiontrue}

\newif\if@fonts
\DeclareOption{fonts}{%
\@fontstrue}

\newif\if@onecolumn
\DeclareOption{onecolumn}{%
\@onecolumntrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}
\if@onecolumn
\@twocolumnfalse
\else
\twocolumn
\fi
\if@production
\usepackage[T1]{fontenc}
\usepackage[nosf]{kpfonts}
\edef\sfdefault{iwonac}
\fi
\if@fonts
\usepackage[T1]{fontenc}
\usepackage[nosf]{kpfonts}
\edef\sfdefault{iwonac}
\fi
\if@doublespace
\RequirePackage[onehalfspacing]{setspace}
\fi

\gdef\set@journalname{Preprint}
\if@production
\gdef\set@journalname{on \@journalname}
\fi

\RequirePackage{graphicx}
\RequirePackage{pifont,latexsym,ifthen,rotating,calc,textcase,booktabs,color,framed}
\RequirePackage{amsfonts,amssymb,amsbsy,amsmath,amsthm}
\RequirePackage{titlesec,enumitem}
\RequirePackage{flushend}
%\RequirePackage{bm}
\RequirePackage[errorshow]{tracefnt}

\@twosidetrue
\flushbottom
\frenchspacing

\textwidth 178mm
\textheight 236mm
\setlength\columnsep{6mm}
\columnwidth 86mm

%Trim sizes
\setlength\voffset{-1in}
\setlength\hoffset{-1in}
\topmargin 10mm
\setlength\oddsidemargin{16mm}%back margin on odd pages
\setlength\evensidemargin{16mm}%fore margin on even pages
\setlength\paperwidth{210mm}
\setlength\paperheight{297mm}
%Needed to set PDF page size
\special{papersize=210mm,297mm}

%\setlength\parskip{6\p@ \@plus \p@}
\setlength\parskip{0\p@ \@plus \p@}
\parindent 1em
\headheight 50pt
\headsep    17pt
\footskip 24pt

\hyphenpenalty=1000
\pretolerance=8000
\tolerance=9500
\hbadness=8000
\vbadness=9000
\displaywidowpenalty=0
\clubpenalty=10000
\widowpenalty=10000
\lefthyphenmin=3%
\righthyphenmin=3%
\brokenpenalty=10000%
\hbadness=10000
\vbadness=10000

\thinmuskip = 3mu
\medmuskip = 4mu
\thickmuskip = 5mu

\setcounter{topnumber}{10}
\def\topfraction{1}
\setcounter{bottomnumber}{10}
\def\bottomfraction{0.8}
\setcounter{totalnumber}{10}
\def\textfraction{0}
\renewcommand{\floatpagefraction}{0.95}
\setcounter{dbltopnumber}{10}
\renewcommand{\dblfloatpagefraction}{0.95}
\renewcommand{\dbltopfraction}{1}

\newcounter{affilcount}
\setcounter{affilcount}{0}

\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt\@xiipt
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
\renewcommand\small{%
   \@setfontsize\small\@ixpt{11}%
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\renewcommand\footnotesize{%
   \@setfontsize\footnotesize\@viiipt{9.5}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\renewcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\renewcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\renewcommand\large{\@setfontsize\large\@xiipt{14}}
\renewcommand\Large{\@setfontsize\Large\@xivpt{18}}
\renewcommand\LARGE{\@setfontsize\LARGE\@xviipt{20}}
\renewcommand\huge{\@setfontsize\huge\@xxpt{23}}
\renewcommand\Huge{\@setfontsize\Huge\@xxvpt{30}}

\definecolor{ICSTgray}{gray}{0.5}
\definecolor{ICSTblue}{cmyk}{0.89,0.44,0.22,0.17}

\def\articletype#1{%
\gdef\@articletype{{#1}}}
\let\@articletype\@empty

\def\journalname#1{%
\gdef\@journalname{{#1}}}
\let\@journalname\@empty

\def\copyrightline#1{%
\gdef\@copyrightline{{#1}}}
\let\@copyrightline\@empty


%\if@production
\gdef\@copyrightline{Copyright\ \copyright\ \volumeyear\ \copyrightholder}
\newcommand\copyrightnote[1]{%
  \g@addto@macro\@copyrightline{{. #1}}}
\let\@copyrightnote\@empty
%\fi

\def\doiline#1{%
\gdef\@doiline{{#1}}}
\let\@doiline\@empty

%\if@production
\gdef\@doiline{{doi:}\articledoi}
%\fi

\newlength\abswidth
\setlength{\abswidth}{\textwidth}
\addtolength{\abswidth}{-24pt}

\newenvironment{tintbox}{%
  \def\FrameCommand{\setlength{\fboxsep}{12pt}\colorbox{ICSTblue}}%
  \MakeFramed {\advance\hsize-\width\FrameRestore}}%
 {\endMakeFramed}

\long\def\abstract#1{\gdef\@abstract{%
\setlength\parskip{10\p@ \@plus \p@}\parindent 0pt\section*{\abstractname}\vspace*{-12pt}%
\begin{tintbox}\vspace*{-10pt}{\color{white}#1}\end{tintbox}}
}

\def\@endabstract{}
\def\endabstract{\gdef\@endabstract{}}
\let\@abstract\@empty

\def\keywords#1{%
  \gdef\@keywords{\textbf{Keywords:}\hspace{0.75em}{#1}}}
\let\@keywords\@empty

\skip\footins 22pt plus  8pt
%\gdef\footnoterule{}
\def\footnoterule{\kern-3\p@
  \hrule \@width \columnwidth \kern 2.6\p@}

%\renewcommand{\thefootnote}{\fnsymbol{footnote}}
\long\def\@makefntext#1{\parindent 1em%
\noindent{$\m@th^{\@thefnmark}$}#1}

%\footnotesep 10pt

\def\corraddr#1{%
  \gdef\@corraddr{%
   {\footnotetext[0]{$^{\text{*}}$Correspondence to: #1}}}}
\let\@corraddr\@empty
\def\corrauth{$^{\text{*}}$}

\def\address#1{%
  \gdef\@address{{#1}}}
\let\@address\@empty

\def\received#1{%
  \gdef\@received{Received on #1}}
\let\@received\@empty

\newcommand\accepted[2][accepted on]{%
  \g@addto@macro\@accepted{{; #1 #2}}}
\let\@accepted\@empty

\newcommand\published[2][published on]{%
  \g@addto@macro\@published{{; #1 #2}}}
\let\@published\@empty

\newcommand\corrected[2][corrected on]{%
  \g@addto@macro\@corrected{{; #1 #2}}}
\let\@corrected\@empty

%%%%%%%Begin new title page footnote macros
\let\comma\@empty
\let\tnotesep\@empty

\def\icstLabel#1{\@bsphack\protected@write\@auxout{}%
         {\string\Newlabel{#1}{\@currentlabel}}\@esphack}
\def\Newlabel#1#2{\expandafter\xdef\csname X@#1\endcsname{#2}}

\def\icstRef#1{\@ifundefined{X@#1}{0}{\csname X@#1\endcsname}%
}

\def\tnotemark[#1]{\textsuperscript{\@for\@@tmark:=#1\do{%
      \edef\tnotenum{\@ifundefined{X@\@@tmark}{1}{\icstRef{\@@tmark}}}%
      \ifcase\tnotenum\or\ding{72}\or,\ding{72}\ding{72}\fi}}%
}
\let\@tnotemark\@empty

\let\@tnotes\@empty
%\RequirePackage{pifont}
\newcounter{tnote}
\def\tnotetext[#1]#2{\g@addto@macro\@tnotes{%
  \refstepcounter{tnote}\icstLabel{#1}%
   \def\thefootnote{\ifcase\c@tnote\or\text{\ding{72}}\or\text{\ding{72}\ding{72}}\fi}%
    \footnotetext{#2}}}

\def\fnotemark[#1]{\textsuperscript{\@for\@@tmark:=#1\do{%
      \edef\fnotenum{\@ifundefined{X@\@@tmark}{1}{\icstRef{\@@tmark}}}%
      \ifcase\fnotenum\or%
      \ifthenelse{\value{affilcount}=0}{$*$}{,$*$}%
      \or ,$\dagger$\or ,$\ddagger$\or
   ,$\mathsection$\or ,$\mathparagraph$\or ,$\|$\or ,$**$\or ,$\dagger\dagger$
   \or ,$\ddagger\ddagger$\fi}}%
}
\let\@fnotemark\@empty

\let\@fnotes\@empty
%\RequirePackage{pifont}
\newcounter{fnote}
\def\fnotetext[#1]#2{\g@addto@macro\@fnotes{%
  \refstepcounter{fnote}\icstLabel{#1}%
   \def\thefootnote{\ifcase\c@fnote\or *\or \dagger\or \ddagger\or
   \mathsection\or \mathparagraph\or \|\or **\or \dagger\dagger
   \or \ddagger\ddagger\fi}%
    \footnotetext{#2}}}

%\def\fnref#1{\fnmark[#1]}
\def\tnoteref#1{\tnotemark[#1]}
\def\fnoteref#1{\fnotemark[#1]}

\def\resetTitleCounters{\c@fnote=0 \c@tnote=0}

\def\printFirstPageNotes{%
  \ifx\@tnotes\@empty\else\@tnotes\fi
   \ifx\@fnotes\@empty\else\@fnotes\fi
}

\newcommand{\email}[1]{\href{mailto:<#1>}{#1}}

%%%%%%%End new title page footnote macros



%%\def\cgsn#1#2{%
%%\gdef\@cgsn{%
%%\footnotetext[0]{%
%%Contract/grant sponsor: #1; contract/grant
%%number: #2}}}
%%
%%\def\cgs#1{%
%%\gdef\@cgs{%
%%\footnotetext[0]{%
%%Contract/grant sponsor: #1}}}
%%
%%\let\@cgsn\@empty
%%\let\@cgs\@empty

\def\affilnum#1{${}^{#1}$\ignorespaces}
\def\affil#1{${}^{#1}$\setcounter{affilcount}{1}}
%%\def\comma{${}^{\text{,}}$}

\renewcommand\maketitle{\par
  \begingroup%
     \if@twocolumn%
      \ifnum \col@number=\@ne%
        \@maketitle%
      \else
        \twocolumn[\@maketitle]%
       \fi
    \else
      \newpage%
      \global\@topnum\z@% Prevents figures from going at top of page.
      \@maketitle%
    \fi
    \thispagestyle{title}\label{FirstPage}\printFirstPageNotes%\@corraddr\@address\@cgs\@cgsn
      \endgroup
  %\setcounter{footnote}{0}%
  \global\let\address\relax
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\@address\@empty
  \global\let\corraddr\relax
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{\if@twocolumn\vspace*{-12pt}\else\vspace*{-32pt}\fi%
\null%
  {\raggedright\huge\color{ICSTblue}\bfseries\@title \par}%
    \vskip 12pt %
    {\large%
      \noindent\@author\par}%
      \vskip 11pt%
{\normalsize
      {\raggedright\@address}
      \par}
      \ifx\@abstract\@empty\addvspace{12pt}\else\addvspace{7pt}%
          {\@abstract \@endabstract}\fi%
     \centering\begin{minipage}{\abswidth}
    \ifx\@received\@empty\else\vspace*{6pt}%
    {\small\@received\@accepted\@published\@corrected\par}\fi
    \ifx\@keywords\@empty\else\addvspace{3pt}%
   {\small\noindent\@keywords\par}\fi
    \ifx\@copyrightline\@empty\else\addvspace{3pt}%
    {\small\@copyrightline\par}\fi
    \ifx\@doiline\@empty\else\addvspace{3pt}%
    {\small\@doiline\par}\fi
    \end{minipage}
     \vspace*{24pt}%
        \par%
        }

\def\startpage{\pageref{FirstPage}}
\def\endpage{\pageref{LastPage}}
\def\volumeyear{0000}
\def\volumenumber{00}
\def\issuemonth{XXXX}
\def\issuenumber{00}
\def\articleid{0000-0000}
\def\copyrightholder{ICST}
\def\articledoi{xx.yyy/trans.journalid.V.n.i}

\def\runningheads#1#2{\markboth{{#1}}{{#2}}}

%\gdef\titlepagefooter{%
%\parbox[b]{\textwidth}{%
%\tabcolsep 3pt\footnotesize\sf
%\begin{tabular}[t]{@{}lll@{}}
%\smash{\raisebox{-10pt}{\includegraphics[width=20mm]{ICSTLogo3}}}&ICST \volumeyear\ www.create-net.org\\
%&Via alla Cascata 56/D Povo, 38123 Trento - Italy
%\end{tabular}\hfill%
%\begin{tabular}[t]{@{}r@{}}
%ICST Transactions\ \set@journalname\\
%\issuemonth\ \volumeyear\ $\mid$ Volume \volumenumber\ $\mid$ Issue \issuenumber\  $\mid$ ISSN \issnnumber
%\end{tabular}
%}}

\gdef\set@rhtitlepagefooter{EAI Endorsed Transactions Preprint}
\if@production
\gdef\set@rhtitlepagefooter{EAI Endorsed Transactions\ \set@journalname\\
\issuemonth\ \volumeyear\ $\mid$ Volume \volumenumber\ $\mid$ Issue \issuenumber\  $\mid$ \articleid}
\fi

\gdef\titlepagefooter{%
\parbox[b]{80mm}{%
\tabcolsep 3pt\footnotesize\sf%
\begin{tabular}[t]{@{}l@{}}
{\raisebox{-11.25pt}{\if@production\includegraphics[width=25mm]{icstlogo3}\fi}}\\
\end{tabular}}\hfill%
\hfill\footnotesize\sf\begin{tabular}[t]{@{}c@{}}
$\phantom{0}$\\
{\thepage}
\end{tabular}\hfill%
\parbox[b]{80mm}{%
\tabcolsep 3pt\footnotesize\sf%
\hfill\begin{tabular}[t]{@{}r@{}}
\set@rhtitlepagefooter
\end{tabular}%
}}

\def\ps@title{%
\def\@oddhead{%
\parbox[b]{\textwidth}{%
\if@production\includegraphics[width=10mm]{icstlogo1}\hspace{-10mm}\fi{\sf\bfseries\huge EAI Endorsed Transactions\,\large\set@journalname\hfill%
\normalfont\large{\color{ICSTgray}\@articletype}\ \ \raisebox{-0.5pt}{{\if@production\includegraphics[width=15mm]{icstlogo2}\fi}}}\\[-6pt]
\noindent\rule{\textwidth}{1.0pt}}}%
\let\@evenhead\@oddhead
\def\@oddfoot{%
\titlepagefooter%
}
\let\@evenfoot\@oddfoot}

\def\ps@icstpage{
\let\@mkboth\@gobbletwo
\def\@evenhead{\parbox[b]{\textwidth}{%
\mbox{}\small\sf{\leftmark}\hfill\mbox{}\\[-2pt]
\noindent\rule{\textwidth}{0.5pt}}}
\def\@oddhead{\parbox[b]{\textwidth}{%
\mbox{}\hfill\small\sf{\rightmark}\mbox{}\\[-2pt]
\noindent\rule{\textwidth}{0.5pt}}}
\def\@evenfoot{%
\titlepagefooter}
\def\@oddfoot{\@evenfoot}
}

\renewcommand\appendix{\par
%\setcounter{section}{0}%
\setcounter{subsection}{0}%
\setcounter{figure}{0}%
\setcounter{table}{0}%
\setcounter{equation}{0}%
\def\thefigure{\thesection.\arabic{figure}}%
\def\thetable{\thesection.\arabic{table}}%
\def\theequation{\thesection.\arabic{equation}}%
\gdef\thesection{\@Alph\c@section}}

\setcounter{secnumdepth}{2}
\titlelabel{\thetitle.}

%\newcommand*\sectitle[1]{%
%\normalfont\large\sf\bfseries\raggedright}

\titleformat{\section}[block]
{\normalfont\large\sf\bfseries\color{ICSTblue}}
{\thesection.}
{0.5em}
{\normalfont\large\sf\bfseries\raggedright}

\newcommand{\appmark}{}
\newenvironment{appendices}
{\setcounter{section}{0}\appendix\renewcommand{\appmark}{Appendix~}}
{}
\titleformat{\section}[block]
{\normalfont\large\sf\bfseries\color{ICSTblue}}
{\appmark\thesection.}
{0.5em}
{\normalfont\large\sf\bfseries\raggedright}

\titlespacing*{\section}{0pt}{12pt \@plus 2pt \@minus 2pt}{6pt\@plus 2pt \@minus 2pt}

\titleformat{\subsection}[block]
{\normalfont\large\sf\color{ICSTblue}}
{\thesubsection.}
{0.5em}
{\normalfont\large\sf\raggedright}

\titlespacing*{\subsection}{0pt}{12pt \@plus 2pt \@minus 2pt}{6pt\@plus 2pt \@minus 2pt}

\newcommand{\periodafter}[1]{#1.}

\titleformat{\subsubsection}[runin]
{\normalfont\normalsize\sf\bfseries\color{ICSTblue}}
{\thesubsubsection.}
{0.5em}
{\normalfont\normalsize\sf\bfseries\periodafter}

\titlespacing*{\subsubsection}{0pt}{6pt \@plus 2pt \@minus 2pt}{1em}

\setlist{partopsep=0pt,topsep=6pt \@plus 1pt \@minus 1pt}

%\renewcommand{\thetable}{\Roman{table}}
\renewcommand{\figurename}{Figure}

\usepackage{caption}
\DeclareCaptionLabelSeparator{icstperiod}{.\hspace*{0.5em}}
\captionsetup[figure]{font={normalsize,sf},labelfont=bf,labelsep=icstperiod,justification=justified,singlelinecheck=true}
\captionsetup[table]{position=top,font={normalsize,sf},labelfont=bf,labelsep=icstperiod,justification=justified,singlelinecheck=true}

%\def\thmhead@plain#1#2#3{%
%  \thmname{#1}\thmnumber{\@ifnotempty{#1}{ }{#2}}%
%  \thmnote{ {\the\thm@notefont(#3)}}}

\newtheoremstyle{icst}
{6pt plus 2pt minus 2pt}% space above
{6pt plus 2pt minus 2pt}% space below
{\normalfont}% Body font
{}% Indent amount
{\normalfont\normalsize\sf\bfseries\color{ICSTblue}}% Theorem head font
{.}% Punctuation after theorem head
{ }% Space after theorem head
{}% Theorem head spec

\theoremstyle{icst}

\newcommand\ack{\vspace{6pt}\subsubsection*{Acknowledgement}\small}
\newcommand\acks{\vspace{6pt}\subsubsection*{Acknowledgements}\small}

\renewcommand\refname{References}
\usepackage[numbers,sort&compress]{natbib}
\setlength{\bibsep}{0pt}
\renewcommand{\bibfont}{\small}
\let\cite\citep

%\renewenvironment{thebibliography}[1]{%
%\section*{\refname}
%\list{{\arabic{enumi}}}{\def\makelabel##1{\hss{[##1]}}\topsep=0\p@\parsep=0\p@
%\partopsep=0\p@\itemsep=3\p@
%\labelsep=1ex\itemindent=0\p@
%\settowidth\labelwidth{\small[#1]}%
%\leftmargin\labelwidth
%\advance\leftmargin\labelsep
%\advance\leftmargin -\itemindent
%\usecounter{enumi}}\small
%\def\newblock{\ }
%\sloppy\clubpenalty4000\widowpenalty4000
%\sfcode`\.=1000\relax}{\endlist}

%\def\biog{\section*{Author's Biography}\small}
%\def\biogs{\section*{Authors' Biographies}\small}

\AtEndDocument{%
\label{LastPage}}

\hyphenation{com-mu-ni-ca-tions}

\pagestyle{icstpage}
\sloppy
