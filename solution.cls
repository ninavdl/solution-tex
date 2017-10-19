% Format solutions for exercise sheets

% Licensed under MIT License
% https://github.com/sour-dough/solution-tex

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{solution}[2017/10/15 exercise sheet solution]

\LoadClass{article}

\usepackage{geometry}
\geometry{
	a4paper,
	total={165mm,252mm},
	left=25mm,
	top=25mm,
}

\usepackage{ifxetex}

\ifxetex
\usepackage{fontspec}
\else
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{lmodern}
\fi

\usepackage{titlesec}
\usepackage{etoolbox}
\usepackage{ifthen}
\usepackage{color}
\usepackage{fancyhdr}
\usepackage{pgfkeys}
\usepackage{amssymb,amsmath,amsthm,mathtools} %common math libs, standard on all PCs
\usepackage{changepage}
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{calc}
\usepackage{fp}

\setlength{\parindent}{0pt}
\setlength{\parskip}{3pt}

\newcommand{\lSheet}{Sheet}
\newcommand{\lGroup}{Group}
\newcommand{\lPage}{Page}
\newcommand{\lPoints}{Points}
\newcommand{\lExercise}{Exercise}
\newcommand{\lOf}{of}
\newcommand{\lPoint}{Point}
\newcommand{\lPointsNom}{Points}
\newcommand{\setgerman}{
	\renewcommand{\lSheet}{Blatt}
	\renewcommand{\lGroup}{Gruppe}
	\renewcommand{\lPage}{Seite}
	\renewcommand{\lPoints}{Punkten}
	\renewcommand{\lExercise}{Aufgabe}
	\renewcommand{\lOf}{von}
	\renewcommand{\lPoint}{Punkt}
	\renewcommand{\lPointsNom}{Punkte}
	\usepackage[ngerman]{babel}
}

\newcommand{\ifempty}[3]{%
	\setbox0=\hbox{#1\unskip}\ifdim\wd0=0pt
	#2%
	\else%
	#3%
	\fi%
}


\newcommand{\sheetnum}{}
\newcommand{\setsheetnum}[1]{
	\renewcommand{\sheetnum}{#1}
}

\newcommand{\module}{}
\newcommand{\setmodule}[1]{
	\renewcommand{\module}{#1}
}

\newcommand{\group}{}
\newcommand{\setgroupnum}[1]{
	\renewcommand{\group}{\\\vspace{4pt}\textbf{\lGroup~#1}}
}

\newcounter{author}
\newcommand{\addauthor}[2]{%
	\csdef{authorName\theauthor}{#1}
	\csdef{authorNum\theauthor}{#2}
	\stepcounter{author}
}

\newcommand{\getauthorName}[1]{%
	\csuse{authorName#1}%
}

\newcommand{\getauthorNum}[1]{%
	\csuse{authorNum#1}%
}

\newcommand{\getauthorFull}[1]{%
	\getauthorName{#1}~(\getauthorNum{#1})%
}

\newcounter{ct}
\newcommand{\getauthors}{%
	\setcounter{ct}{0}
	\whiledo{\value{ct} < \value{author}}%
	{%
		\mbox{\getauthorFull{\thect}}%
		\stepcounter{ct}%
		\ifnum \value{ct}=\value{author}{}\else{, }\fi%
	}
}
\newcommand{\getauthorsShort}{%
	\setcounter{ct}{0}
	\whiledo{\value{ct} < \value{author}}%
	{%
		\getauthorNum{\thect}%
		\stepcounter{ct}%
		\ifnum \value{ct}=\value{author}{}\else{, }\fi%
	}
}

\gdef\pointtableSpec{}
\gdef\pointtableHeader{}
\gdef\pointtableValues{}

\newcommand{\pointfield}[1]{%
	\begin{flushright}
		\hrulefill\fbox{
			~~~~~~\ifempty{#1}{}{/~#1}
		}
	\end{flushright}
}

\newcounter{subexercises}
%\newcounter{exerciseSumPoints}
%\newcounter{sumPoints}
\FPset\sumPoints{0}
\gdef\sumPointsPlus{}

\newenvironment{exercise}[2][NONE]{
	\section{#2}
	\ifcsname thefirstExercise\endcsname\else%
	\newcounter{firstExercise}%
	\setcounter{firstExercise}{\value{section}}%
	\fi%
	\csdef{exercisePoints\thesection}{#1}%
	\setcounter{subexercises}{0}%
	\FPset\exerciseSumPoints{0}%
	\xdef\exerciseSumPoints{\exerciseSumPoints} % make global
}{%
	\xdef\pointfieldContent{}
	\ifthenelse{\equal{\csuse{exercisePoints\thesection}}{NONE}}{%
		\setcounter{ct}{0}%
		\whiledo{\value{ct} < \value{subexercises}}%
		{%
			\stepcounter{ct}%
			\xdef\pointfieldContent{%
				\pointfieldContent \csuse{subexercisePoints\thect}%
				\ifnum \value{ct}=\value{subexercises}{}\else{+}\fi%
			}%
		}%
	}{%
		\xdef\pointfieldContent{\csuse{exercisePoints\thesection}}%
		\edef\temp{(exerciseSumPoints) + \csuse{exercisePoints\thesection}}%
		\FPeval\exerciseSumPoints{\temp}%
		\xdef\exerciseSumPoints{\exerciseSumPoints} % make global
	}%
	
	\pointfield{\pointfieldContent}%
	
	\vspace{1cm}
	\xdef\pointtableSpec{\pointtableSpec c|}%
	\edef\tempA{\thesection &}%
	\expandafter\gappto\expandafter\pointtableHeader\expandafter{\tempA}%
	\FPifeq{\exerciseSumPoints}{0}%
	\edef\tempB{~~~~ / ~~ &}%
	\gdef\sumPointsPlus{ +~~~~~}%
	\else%
	\FPclip\exerciseSumPoints\exerciseSumPoints %
	\edef\tempB{~~~~ / \exerciseSumPoints &}%
	\FPadd\sumPoints\sumPoints\exerciseSumPoints%
	\xdef\sumPoints{\sumPoints} % make global
	%\addtocounter{sumPoints}{\value{exerciseSumPoints}}%
	\fi%
	\expandafter\gappto\expandafter\pointtableValues\expandafter{\tempB}%
}

\newenvironment{subexercise}[2][]{
	\subsection{#2}
	\stepcounter{subexercises}%
	\expandafter\gdef\csname subexercisePoints\arabic{subexercises}\endcsname{#1}%
	%\ifempty{#1}{}{\addtocounter{exerciseSumPoints}{\numexpr#1}}
	\ifempty{#1}{}{%
		\edef\temp{(exerciseSumPoints) + #1}%
		\FPeval{\exerciseSumPoints}{\temp}%
		\xdef\exerciseSumPoints{\exerciseSumPoints} % make global
	}
	\adjustwidth{1.75em}{0pt}%
	\def\temp{#2}\ifx\temp\empty\vspace{-1.25\baselineskip}\fi%
}{\endadjustwidth}

\newenvironment{subsubexercise}[2][\unskip]{
	\subsubsection{#2}
	\adjustwidth{1.75em}{0pt}%
	\def\temp{#2}\ifx\temp\empty\vspace{-1.25\baselineskip}\fi
}{\endadjustwidth}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\footnotesize \module~(\lSheet~\sheetnum)}
\fancyhead[R]{\footnotesize \getauthorsShort}
\fancyfoot[C]{\thepage}

\renewcommand{\thesubsection}{\alph{subsection}}
\renewcommand{\thesubsubsection}{\roman{subsubsection}}

\newcommand{\colonafter}[1]{\def\temp{#1}\ifx\temp\empty\else~#1:\fi}

\titleformat{\subsection}[runin]{
	\normalfont}
{(\thesubsection)}{1pt}
{\bfseries\colonafter}

\titleformat{\subsubsection}[runin]
{\normalfont}
{(\thesubsubsection)}{1pt}
{\bfseries\colonafter}

\titleformat{\section}
{\normalfont\Large\bfseries}
{\lExercise~\thesection:}
{1em}
{\normalfont}

\renewcommand{\maketitle}{
	\thispagestyle{plain}
	\fancyfoot[C]{\thepage}
	{\hrule\vspace{4pt}\centering
		{\huge \textbf{\module}~(\lSheet~\sheetnum)}\\\vspace{4pt}
		{\large \getauthors \group}\\
		\hrulefill}
}


\newcommand{\todo}[1][]{{\color{red}TODO% 
		\ifx #1\empty\else: #1\fi%
}}

\newcommand{\pointtable}{
	\ifcsname pointtableSpecSaved\endcsname%
	\begin{table}[h!]\centering\begin{tabular}{\pointtableSpecSaved}
			\pointtableHeaderSaved \\\hline
			\pointtableValuesSaved
	\end{tabular}\end{table}%
	\else
	{\color{red}\Large COMPILE AGAIN}%
	\ClassWarning{Compile again!}%
	\fi%
}

\AtEndDocument{
	\makeatletter
	\immediate\write\@mainaux{\string\gdef\string\pointtableSpecSaved{\pointtableSpec c}}%
	\immediate\write\@mainaux{\string\gdef\string\pointtableHeaderSaved{\pointtableHeader $\Sigma$}}%
	\FPclip\sumPoints\sumPoints%
	\immediate\write\@mainaux{\string\gdef\string\pointtableValuesSaved{\pointtableValues ~~~~/~\sumPoints\sumPointsPlus}}%
	\makeatother
}
