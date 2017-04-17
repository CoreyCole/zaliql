%% This is file `dalthesis.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% dalthesis.dtx  (with options: `class')
%% dalthesis.ins  (installation file)
%%
%% Dalhousie University Thesis Document Class
%% Version 2.2 &lt;2003/12/12&gt;
%% by Ian Nunn (2005)
%% Adapted from:
%%    Version 2.2 &lt;2003/12/12&gt;
%%    by Clyde Clements
%% Adapted from:
%%    LaTeX 2.09 `dalthesis.sty' file
%%    by Steven Matheson (1992)
%%    This was based on the Stanford University
%%    Ph.D. thesis style by Joseph Pallas (1988).
%%
%% This is a LaTeX2e class file which is intended
%% to meet the requirements for theses produced at
%% Dalhousie University, Canada.
%%
%% IMPORTANT NOTICE:
%%
%% This is a generated file.
%%
%% This file is free and may be distributed as long
%% as the original source files, as listed above,
%% are part of the same distribution. (The sources
%% need not necessarily be in the same archive or
%% directory.)
%%
%% Any modified versions of this file must be renamed
%% with new filenames distinct from `dalthesis.cls'.
%%
%% Please direct questions, comments, suggestions, etc.
%% to: clyde@mathstat.dal.ca
%%
\def\fileversion{2.2}
\def\filedate{2003/12/12}
\def\docdate{2003/12/12}


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dalthesis}
   [\filedate\space v\fileversion\space
    Dalhousie University thesis class]
\newif\ifdal@title@page        \dal@title@pagetrue
\newif\ifdal@contents@page     \dal@contents@pagetrue
\newif\ifdal@tables@page       \dal@tables@pagetrue
\newif\ifdal@figures@page      \dal@figures@pagetrue
\newif\ifdal@dedication@page   \dal@dedication@pagetrue
\newif\ifdal@dedication        \dal@dedicationfalse
\newif\ifdal@phd               \dal@phdfalse
\newif\ifdal@draft@mode        \dal@draft@modefalse
\newif\ifdal@print@bib         \dal@print@bibtrue
\newif\ifdal@first@bibitem     \dal@first@bibitemtrue
\newif\ifdal@in@preface        \dal@in@prefacefalse
\newcommand{\dal@ptsize}{12pt}
\DeclareOption{10pt}{\renewcommand{\dal@ptsize}{10pt}}
\DeclareOption{11pt}{\renewcommand{\dal@ptsize}{11pt}}
\DeclareOption{12pt}{} % \dal@ptsize already set to 12pt
\DeclareOption{draft}{\AtEndOfClass{\draft}
   \PassOptionsToClass{draft}{report}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
\LoadClass[\dal@ptsize]{report}
\RequirePackage{afterpage}
\setlength{\headsep}{\baselineskip}
\setlength{\topmargin}{0pt}
\setlength{\oddsidemargin}{0.5in}
\setlength{\evensidemargin}{0in}
\setlength{\textwidth}{\paperwidth}
\addtolength{\textwidth}{-2.5in}
\newlength{\dal@textheight@default}
\setlength{\dal@textheight@default}{\paperheight}
\addtolength{\dal@textheight@default}{-2in}
\addtolength{\dal@textheight@default}{-\topmargin}
\addtolength{\dal@textheight@default}{-\headheight}
\addtolength{\dal@textheight@default}{-\headsep}
\newlength{\dal@textheight@footer}
\setlength{\dal@textheight@footer}{\dal@textheight@default}
\addtolength{\dal@textheight@footer}{-\footskip}
\setlength{\textheight}{\dal@textheight@default}
\newcommand{\dal@set@textheight}[1]{%
   \global\textheight=#1%
   \global\@colht=#1%
   \global\@colroom=#1%
   \global\vsize=#1%
   \@floatplacement%
}
\newcommand{\dal@add@textheight}[1]{%
   \global\advance\textheight by #1%
   \global\advance\@colht by #1%
   \global\advance\@colroom by #1%
   \global\advance\vsize by #1%
   \@floatplacement%
}
\renewcommand\chapter{%
   \if@openright\cleardoublepage\else\clearpage\fi
   \ifdal@in@preface\else\dal@add@textheight{-\footskip}\fi%
   \thispagestyle{plain}%
   \global\@topnum\z@
   \@afterindentfalse
   \secdef\dal@chapter\dal@schapter%
}
\def\dal@chapter[#1]#2{%
   \ifnum \c@secnumdepth >\m@ne
      \refstepcounter{chapter}%
      \typeout{\@chapapp\space\thechapter.}%
      \addcontentsline{toc}{chapter}%
         {\protect\numberline{\@chapapp\space\thechapter}#1}%
   \else
      \addcontentsline{toc}{chapter}{#1}%
   \fi
   \chaptermark{#1}%
   \addtocontents{lof}{\protect\addvspace{10\p@}}%
   \addtocontents{lot}{\protect\addvspace{10\p@}}%
   \if@twocolumn
      \@topnewpage[\@makechapterhead{#2}]%
   \else
      \@makechapterhead{#2}%
      \@afterheading
   \fi%
   \ifdal@in@preface\else\afterpage{\dal@add@textheight{\footskip}}\fi%
}
\def\dal@schapter#1{%
   \@schapter{#1}%
   \ifdal@in@preface\else\afterpage{\dal@add@textheight{\footskip}}\fi%
}
\newdimen\dal@tempdima
\newdimen\dal@tempdimb
\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth>\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \settowidth\dal@tempdima{\chaptername\ }%
    \settowidth\dal@tempdimb{\appendixname\ }%
    \ifdim\dal@tempdima>\dal@tempdimb
       \setlength\@tempdima{\dal@tempdima}%
    \else
       \setlength\@tempdima{\dal@tempdimb}%
    \fi%
    \addtolength\@tempdima{2.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi%
}
\flushbottom
\setlength{\marginparwidth}{40pt}
\setlength{\marginparsep}{10pt}
\newcommand{\properpagestyle}{%
   \pagestyle{myheadings}\markboth{}{}\markright{}}
\brokenpenalty=10000
\linespread{1.37}\normalsize
\renewenvironment{figure}
               {\linespread{1}\@float{figure}}
               {\end@float}
\renewenvironment{figure*}
               {\linespread{1}\@dblfloat{figure}}
               {\end@dblfloat}
\renewenvironment{table}
               {\linespread{1}\@float{table}}
               {\end@float}
\renewenvironment{table*}
               {\linespread{1}\@dblfloat{table}}
               {\end@dblfloat}
\def\@makechapterhead#1{%
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
        \large\bfseries \@chapapp\space \thechapter
        \par\nobreak
        \vskip 0.8\baselineskip
    \fi
    \interlinepenalty\@M
    \large \bfseries #1\par\nobreak
    \vskip \baselineskip
  }}
\def\@makeschapterhead#1{%
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \large \bfseries  #1\par\nobreak
    \vskip \baselineskip
  }}
\renewcommand\section{\@startsection {section}{1}{\z@}%
   {-3.5ex \@plus -1ex \@minus -.2ex}%
   {2.3ex \@plus.2ex}%
   {\normalfont\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
   {-3.25ex\@plus -1ex \@minus -.2ex}%
   {1.5ex \@plus .2ex}%
   {\normalfont\bfseries}}
\long\def\@caption#1[#2]#3{%
  \par
  \edef\test{\csname ext@#1\endcsname}%
  \def\@tempa{lof}%
  \def\@tempb{lot}%
  \ifx\test\@tempa%
     \addcontentsline{lof}{#1}%
       {\protect\numberline{\figurename\space\thefigure}%
        {\ignorespaces #2}}%
  \else\ifx\test\@tempb%
     \addcontentsline{lot}{#1}%
       {\protect\numberline{\tablename\space\thetable}%
        {\ignorespaces #2}}%
  \else%
     \addcontentsline{\csname ext@#1\endcsname}{#1}%
       {\protect\numberline{\csname the#1\endcsname}{\ignorespaces #2}}%
  \fi\fi%
  \begingroup
    \@parboxrestore
    \if@minipage
      \@setminipage
    \fi
    \normalsize
    \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}
\renewcommand*\l@figure{%
   \settowidth\@tempdima{\figurename\ }%
   \addtolength\@tempdima{2.3em}%
   \@dottedtocline{1}{1.5em}{\@tempdima}}
\renewcommand*\l@table{%
   \settowidth\@tempdima{\tablename\ }%
   \addtolength\@tempdima{2.3em}%
   \@dottedtocline{1}{1.5em}{\@tempdima}}
\long\def\@footnotetext#1{\insert\footins{%
    \linespread{1} % Set single-spacing
    \reset@font\footnotesize
    \interlinepenalty\interfootnotelinepenalty
    \splittopskip\footnotesep
    \splitmaxdepth \dp\strutbox \floatingpenalty \@MM
    \hsize\columnwidth \@parboxrestore
    \protected@edef\@currentlabel{%
       \csname p@footnote\endcsname\@thefnmark
    }%
    \color@begingroup
      \@makefntext{%
        \rule\z@\footnotesep\ignorespaces#1\@finalstrut\strutbox}
    \color@endgroup}%
   }
\long\def\@mpfootnotetext#1{%
  \global\setbox\@mpfootins\vbox{%
    \unvbox\@mpfootins
    \linespread{1} % Set single-spacing
    \reset@font\footnotesize
    \hsize\columnwidth
    \@parboxrestore
    \protected@edef\@currentlabel
         {\csname p@mpfootnote\endcsname\@thefnmark}%
    \color@begingroup
      \@makefntext{%
        \rule\z@\footnotesep\ignorespaces#1\@finalstrut\strutbox}%
    \color@endgroup}%
   }
\AtBeginDocument{%
\let\orig@thebibliography\thebibliography
\renewcommand{\thebibliography}[1]{%
   \clearpage   % necessary to get correct page number in toc
   \ifdal@print@bib
      \addcontentsline{toc}{chapter}{\bibname}
      \linespread{1}\normalsize
      \orig@thebibliography{#1}
   \else
      \newbox\dal@bib@box
      \newbox\dal@bibitem@box
      \let\b@group={
      \let\e@group=}
      \def\endthebibliography{\egroup\e@group}
      \let\orig@bibitem\bibitem
      \def\bibitem{%
         \ifdal@first@bibitem
            \dal@first@bibitemfalse
         \else
            \egroup
         \fi
         \setbox\dal@bibitem@box=\vbox\bgroup
         \orig@bibitem}
      \setbox\dal@bib@box=\vbox\b@group
      \if@filesw
         \immediate\write\@auxout{\string\@writefile{toc}%
            {\string\contentsline \space{chapter}{\bibname}{\thepage}}}
      \fi
      \orig@thebibliography{#1}
   \fi
   }
}
\def\university#1{\gdef\@university{#1}}
\def\address#1{\gdef\@address{#1}}
\def\dept#1{\gdef\@dept{#1}}
\def\faculty#1{\gdef\@faculty{#1}%
   \def\@tempa{#1}
   \def\@tempb{Engineering}
   \ifx\@tempa\@tempb
      \dal@fac@engineeringtrue
   \fi
}
\def\submitdate#1{\gdef\@submitdate{#1}}
\def\copyrightyear#1{\gdef\@copyrightyear{#1}}
\def\degree#1{\gdef\@degree{#1}}
\def\degreeinitial#1{\gdef\@degreeinitial{#1}}
\def\bschon{\degree{Bachelor of Science, Honours}\degreeinitial{B.Sc.~(Hon)}}
\def\masc{\degree{Master of Applied Science}\degreeinitial{M.A.Sc.}}
\def\msc{\degree{Master of Science}\degreeinitial{M.Sc.}}
\def\phd{\degree{Doctor of Philosophy}\degreeinitial{Ph.D.}\dal@phdtrue}
\def\ma{\degree{Master of Arts}\degreeinitial{M.A.}}
\def\@title{}
\def\@author{}
\def\@university{Carleton University}
\def\@address{Ottawa, Ontario}
\def\@dept{School of Computer Science}
\def\@faculty{Graduate Studies and research}
\def\@submitdate{%
   \ifcase\the\month\or
   January\or February\or March\or April\or May\or June\or
   July\or August\or September\or October\or November\or
   December\fi
   \space \number\the\day, \number\the\year}
\def\@copyrightyear{\number\the\year}
\def\defencedate#1{\gdef\@defencedate{#1}}
\def\@defencedate{%
   \ifcase\the\month\or
   January\or February\or March\or April\or May\or June\or
   July\or August\or September\or October\or November\or
   December\fi,
   \space \number\the\year}
\newcommand{\MakeUppercaseWithNewline}[1]{%
   \begingroup
      \let\orig@newline\\%
      \DeclareRobustCommand{\\}{\orig@newline}%
      \MakeUppercase{#1}%
   \endgroup%
}
\newcommand{\dal@titlepage}{%
   \thispagestyle{empty}%
   \ifdal@draft@mode
     \begin{center}
         \large DRAFT COPY \\
         Printed \today\space\drafttime
      \end{center}
   \fi
   \null\vskip0.5in
   \begin{center}
      \hyphenpenalty=10000\large\MakeUppercaseWithNewline{\@title}
   \end{center}
   \vfill
   \begin{center}
      \rmfamily by\\
      \@author
   \end{center}
   \vfill
   \begin{center}
      \small A thesis submitted to \\
      the Faculty of Graduate Studies and Research \\
      in partial fulfillment of \\
      the requirements for the degree of \\
      \vskip 2.5ex
      \MakeUppercaseWithNewline{\@degree} \\
      \vskip 2.5ex
      \@dept \\
      \vskip 2.5ex
      at \\
      \vskip 2.5ex
      \MakeUppercaseWithNewline{\@university} \\
   \end{center}
   \vfill
   \begin{center}
   \small \@address \\
   \small \@defencedate \\
   \end{center}
   \vskip0.25in
   \begin{center}
      \rmfamily \copyright\ Copyright by \@author, \@copyrightyear
   \end{center}
   \clearpage
   }
\newcommand{\no@breaks}[1]{%
   {\def\\{ \ignorespaces}#1}%
   }
\newenvironment{dal@frontpage}%
   {\list{}{\listparindent \z@%
       \itemindent    \z@%
       \rightmargin   \z@%
       \leftmargin    \z@%
       \parsep        \z@ \@plus\p@}%
    \item\relax}
   {\endlist%
    \vfill
    \clearpage}
\newcommand{\dedicate}[1]{%
   \dal@dedicationtrue
   \gdef\dedication@text{%
      \begin{center}
         \large\em\null\vskip1in#1\vfill
      \end{center}
      }%
   }
\newenvironment{dedication}%
   {\newbox\dedicate@box
    \global\setbox\dedicate@box=\vbox\bgroup
    \begin{center}
    \large\em\null\vskip1in}
   {\vfill%
    \end{center}
    \egroup
    \global\dal@dedicationtrue\gdef\dedication@text{\copy\dedicate@box}}
\renewenvironment{abstract}[1][d]%
   {\newpage
    \if s#1 % abstract to be typeset in single-space
       \linespread{1}\normalsize % Switch to single-spacing
    \fi
    \newcount\ab@page
    \ab@page=-\arabic{page}
    \prefacesection{\abstractname}}
   {\vfil
    \advance \ab@page by \arabic{page}
    \ifnum\ab@page>0
       \ClassWarningNoLine{dalthesis}%
          {Abstract longer than one page}
    \fi}
\newcommand{\ackname}{Acknowledgements}
\newenvironment{acknowledgements}%
   {\prefacesection{\ackname}}
   {\vfil}
\let\acknowledgments\acknowledgements
\let\endacknowledgments\endacknowledgements
\renewcommand{\contentsname}{Table of Contents}
\def\frontmatter{%
   \typeout{Unavoidable over/underfulls may occur in the first^^J%
            few pages of dalthesis. These can usually be ignored.^^J%
            However, if uncorrectable errors occur, notify staff.}
   \pagenumbering{roman}
   \pagestyle{plain}
   \dal@in@prefacetrue
   \ifdal@title@page
      \dal@set@textheight{\dal@textheight@default}
      \dal@titlepage
   \else
      \addtocounter{page}{1}
   \fi
   \dal@set@textheight{\dal@textheight@footer}
   \ifdal@dedication
      \ifdal@dedication@page
         \dedication@text
         \clearpage
      \else
         \addtocounter{page}{1}
      \fi
   \fi
   \ifdal@contents@page
\begin{abstract}

Causality is an important notion that appears at the foundations of many scientific disciplines,   in the practice of technology,   and also in our everyday life. Causality
is crucial to understand and manage {\em uncertainty} in data,   information,   knowledge,   and theories.  In data management
in particular,   there is a need to represent,   characterize and
compute the causes that explain why certain query results
are obtained or not,   or why natural semantic conditions,
such as integrity constraints,   are not satisfied.


The notion of query-answer causality in database was introduced in \cite{Meliou2010a}. This notion is shown to be general enough to be applied to a broad class of database-related applications, such as explaining unexpected
answers to a query result,   diagnosing network malfunctions,   data cleaning,   hypothetical reasoning \cite{Meliou2010a,  Meliou2010b,  Meliou2011a,  Meliou2011b}.

In this thesis,   we establish and investigate connections between query-answer causality and other important forms of reasoning that appear in data management and knowledge representation,   e.g. consistency-based diagnoses \cite{Reiter87},
database repairs and consistent query answering \cite{pods99},   abductive diagnosis \cite{ConsoleT91,  EiterGL95},   and the  view-update problem \cite{BunemanKT02,  benny12a,  benny12b}.  These problems are classified in
\cite{suciuRevDM} as {\em reverse data management problems}.


The unveiled relationships allow us to obtain new results for query-answer causality
and also for the above mentioned related  areas. Furthermore,   we argue that causality in data management can be seen as a very fundamental concept,
to which many other data management problems and notions are connected. In fact,   we suggest causality as a unifying framework for reverse data management problems.

\end{abstract}
      \tableofcontents
      \clearpage
   \else
      \addtocounter{page}{1}
   \fi
   \ifdal@tables@page
      \addcontentsline{toc}{chapter}{\listtablename}
     %\listoftables
      \clearpage
   \fi
   \ifdal@figures@page
      \addcontentsline{toc}{chapter}{\listfigurename}
      \listoffigures
      \clearpage
   \fi
   }
\def\mainmatter{\newpage
        \typeout{Dalthesis preface pages completed.}
        \pagenumbering{arabic}
        \properpagestyle
        \dal@set@textheight{\dal@textheight@default}
        \dal@in@prefacefalse
   }
\def\beforepreface{\frontmatter}
\def\afterpreface{\mainmatter}
\def\nonumchapter#1{%
        \chapter*{#1}
        \addcontentsline{toc}{chapter}{#1}
   }
\def\prefacesection#1{%
        \chapter*{#1}
        \addcontentsline{toc}{chapter}{#1}
   }
\def\draft{%
   \newcount\drafthours
   \newcount\draftmins
   \drafthours\time
   \divide\drafthours 60
   \draftmins=-\drafthours
   \multiply\draftmins 60
   \advance\draftmins \time
   \xdef\drafttime{\two@digits{\the\drafthours}:%
      \two@digits{\the\draftmins}}
   %\let\ps@plain\ps@myheadings
   \def\ps@plain{\let\@mkboth\@gobbletwo
      \def\@oddhead{{\rmfamily\slshape Draft Version -- \today%
         \space\drafttime}\hfil}
      \def\@oddfoot{\reset@font\hfil\thepage\hfil}
      \let\@evenhead\@oddhead\let\@evenfoot\@oddfoot}
   \renewcommand{\properpagestyle}{\pagestyle{myheadings}
      \markright{{\rmfamily Draft Version -- \today\space%
      \drafttime}}}
   \dal@draft@modetrue\properpagestyle
   }
\def\notitlepage{\dal@title@pagefalse}
\def\nodedicationpage{\dal@dedication@pagefalse}
\def\notableofcontents{\dal@contents@pagefalse}
\def\nolistoftables{\dal@tables@pagefalse}
\def\nolistoffigures{\dal@figures@pagefalse}
\def\nofront{%
   \dal@dedication@pagefalse
   \dal@contents@pagefalse
   \dal@tables@pagefalse
   \dal@figures@pagefalse
   }
\def\nobib{\dal@print@bibfalse}
%% switch the following two lines by commenting out one of them
%%\msc
\phd
\properpagestyle
\InputIfFileExists{dalthesis.cfg}
   {\typeout{Local config file dalthesis.cfg used.}}{}
\endinput
%%
%% End of file `dalthesis.cls'.
