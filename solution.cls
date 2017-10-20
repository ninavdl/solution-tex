% Format solutions for exercise sheets
% Created by Nino van der Linden
% Licensed under MIT License
% https://github.com/ninov/solution-tex

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
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{titlesec}
\usepackage{etoolbox}
\usepackage{ifthen}
\usepackage{color}
\usepackage{fancyhdr}
\usepackage{amssymb,amsmath,amsthm,mathtools} %common math libs, standard on all PCs

\setlength{\parindent}{0pt}
\setlength{\parskip}{3pt}

\newcommand{\lSheet}{Sheet}
\newcommand{\lGroup}{Group}
\newcommand{\lPage}{Page}
\newcommand{\setgerman}{
	\renewcommand{\lSheet}{Blatt}
	\renewcommand{\lGroup}{Gruppe}
	\renewcommand{\lPage}{Seite}
	\usepackage[ngerman]{babel}
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


\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\footnotesize \module~(\lSheet~\sheetnum)}
\fancyhead[R]{\footnotesize \getauthorsShort}
\fancyfoot[C]{\thepage}


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
