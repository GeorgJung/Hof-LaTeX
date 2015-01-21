%%  Class hofuniversity by Georg Jung

%   Inspired by uebungsblatt package by Igor Akkerman
%   and by uebungsblatt package by Slim Abdennadher
%   modelled after newcsen class for the German University in Cairo
%   (GUC) by myself.

%   Hof University of Applied Sciences
%   Institute of Information Systems
%   Spring 2014

\def\fileversion{v1.0beta}
\def\filedate{2014/06/11}

%----------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{hofuniversity}[2011/09/20 Georg Jung]
\typeout{New class for courses at Hof University, Germany}
\typeout{HofUniversity: \fileversion\ <\filedate> (Georg Jung)}
%----------------------------------------------------------------------%

%----------------------------------------------------------------------%
%   Document class options:

%     solution   - show solution

%     practice   - compile a practice assignment
%     assignment - compile an assignment
%     popquiz    - compile a popquiz
%     quiz       - compile a quiz
%     mock       - compile a mock exam
%     midterm    - compile the midterm exam
%     final      - compile the final exam
%     makeup     - compile the makeup exam

%     rightlogo  - add a logo to the right header (institute)
%     logo       - add a logo to the left header (class)

%     formula    - add a formula sheet at the end of the assessment
%                  (necessary if formulas are referenced!)

%     nomarktbl  - suppress marking table on first page
%                  (for marked assessments)
%     noid       - suppress student identification form
%                  (e.g., for computerized assessments)
%     nobarcode  - suppress barcode placeholder (e.g., for
%                  computerized assessments)
%     idform     - print student id-form on cover page instead of
%                  barcode
%     nonumber   - suppress numbering
%     coverpage  - generate a cover page (default for quiz, mock exam,
%                  midterm, final, and makeup)
%     nocover    - do not generate a cover page (default for practice
%                  assignment, assignment, popquiz)
%     noinstruct - suppress instructions on cover page

%----------------------------------------------------------------------%
%   Commands for config.tex

%   \Institute{}       - sets the institute
%                        (defaults to "Hof University of Applied Sciences")
%   \Department{}      - sets the department
%                        (defaults to "Institute for Information Systems")
%   \Class{}           - sets the class name
%   \Edition{}         - sets the semester for this class
%   \Lecturer[]{}      - sets the class lecturer (optional short name)
%   \Email{}           - sets the e-mail address of the lecturer
%   \Logo{}            - sets the base name of an image file that
%                        contains a logo
%   \Rightlogo{}       - sets the base name of an image file that
%                        contains a logo (defaults to "iisys_en")

%----------------------------------------------------------------------%
%   Commands for individual files

%   \Assessmenttype{}  - sets an individual assessment type if
%                        necessary (e.g. "Practical Assignment",
%                        usually set through appropriate option)
%   \Number{}          - sets the number of this assessment (usually
%                        set automatically from filename)
%   \Topic{}           - sets the topic of the exercise set
%   \Version{}         - sets the version number, necessary if
%                        multiple versions are prepared
%   \Date{}            - sets the discussion/submission/exam date
%   \Pages             - returns the total number of pages
%   \Scratchpaper{}    - sets the number of pages for jotting paper in
%                        the end (defaults to three for marked exam
%                        types, zero otherwise)
%   \Scratchpages      - returns the number of pages for jotting paper
%                        in the end
%   \Duration{}        - sets the duration of the exam (defaults to
%                        120 min for midterm and 180 min for final and
%                        makeup)
%   \Instructions{}    - sets instructions other than the default for
%                        this exam
%   \Management{}      - adds content of braces to front/cover-page to
%                        include extra administrative information
%                        (e.g., for distinguishing majors or type of
%                        final / mid-final / second makeup)
%   \AddFormula[]{}    - adds a formula for the formula sheet
%                        (optional title)
%   \SolutionSpace{}   - sets a space to be left for the solution if
%                        the solution is not shown
%   \Mark{}            - set marks for sub-exercises (checks if sum is
%                        correct, but no automatic adding)
%   \Bonus{}           - same as \Mark{}, but sets boldfont mark which
%                        is not counted (bonus mark)
%   \checkedItem       - used instead of \item for correct answers in
%                        mcq-environment (checkmark appears when
%                        solution is active

%----------------------------------------------------------------------%
%   Commands for unofficial use only

%   \Exercisename{}       - Sets a name for the exercise header
%                           (default: Exercise)
%   \Bonusname{}          - Sets a name for the bonus exercise header
%                           (default: Bonus Exercise)
%   \Exerciseheadskip{}   - Sets a distance between number, theme and
%                           title
%   \Exerciseskip{}       - Sets the distance between two exercises

%----------------------------------------------------------------------%
%   Environments

%   \begin{exercise}{<marks>}{<theme>}{<title>} ... \end{exercise}
%   \begin{bonusexercise}{<marks>}{<theme>}{<title>} ... \end{bonusexercise}
%   \begin{solution} ... \end{solution}
%   \begin{unsolved} ... \end{unsolved}
%   \begin{mcq} \item ... \checkedItem ... \end{mcq}

%----------------------------------------------------------------------%
%   Counters

%   assessment
%   exercise

%======================================================================%

%----------------------------------------------------------------------%
%   Required packages

\RequirePackage[utf8]{inputenx}
\RequirePackage[a4paper]{geometry}
\RequirePackage{xifthen}
\RequirePackage{verbatim}
\RequirePackage{multido}
\RequirePackage{graphicx}
\RequirePackage{color}
\RequirePackage{fancyhdr}
\RequirePackage{colortbl}
\RequirePackage{amssymb}
\RequirePackage[german, english]{babel}

%----------------------------------------------------------------------%
\makeatletter

%----------------------------------------------------------------------%
%   Language selection

\def\localedef#1#2{
\ifthenelse{ \equal{\locale}{#1} }{
  \selectlanguage{#2}
  \expandafter\def\csname#1\endcsname ##1{##1}
  }{
  \expandafter\def\csname#1\endcsname ##1{}
  }
}

\newcommand\locale{en}%		- Default language is English

%----------------------------------------------------------------------%
%   Flags

\newboolean{solution}%		- Solution is shown
\newboolean{numbered}%		- Assessment is numbered

\newboolean{practice}%		- Assessment is a practice assignment
\newboolean{assignment}%	- Assessment is an assignment
\newboolean{popquiz}%		- Assessment is a pop-quiz
\newboolean{quiz}%		- Assessment is a quiz

\newboolean{mock}%		- Assessment is a mock exam
\newboolean{midterm}%		- Assessment is a midterm exam
\newboolean{final}%		- Assessment is a final exam
\newboolean{makeup}%		- Assessment is a makeup exam

\newboolean{subtitle}%		- A subtitle will be printed
\newboolean{exam}%		- Assessment is some kind of exam
\newboolean{cover}%		- A cover page is generated
\newboolean{identity}%		- A form for name and tutorial is generated
\newboolean{marking}%		- The assessment is marked (no practice, no mock)
\newboolean{logo}%		- A logo is printed on each left header
\newboolean{rightlogo}%		- A logo is printed on each right header
\newboolean{nomarktbl}%		- Suppresses the marking table if true
\newboolean{nobarcode}%		- Suppress printing of a barcode placeholder
\newboolean{noinstruct}%	- Suppress printing of instructions on cover page
\newboolean{management}%	- Add administrative content to front/cover-page
\newboolean{formula}%		- Assessment contains a formula sheet

%----------------------------------------------------------------------%
%   Counters

\newcounter{assessment}
\setcounter{assessment}{1}

\newcounter{exercise}
\setcounter{exercise}{0}

\newcounter{@marktableexercise}
\setcounter{@marktableexercise}{0}

\newcounter{@marktotal}
\setcounter{@marktotal}{0}

\newcounter{@scratchpages}
\setcounter{@scratchpages}{0}

\newcounter{@scratchpage}
\setcounter{@scratchpage}{0}

\newcounter{@currentmarks}
\setcounter{@currentmarks}{0}

\newcounter{@submarkstotal}[exercise]
\setcounter{@submarkstotal}{0}

\newcounter{@subbonustotal}[exercise]
\setcounter{@subbonustotal}{0}

%----------------------------------------------------------------------%
%   Options

\newcommand{\@hofassessmenttitle}{\en{Practice assignment}\de{Übungsblatt}}
\newcommand{\Assessmenttype}[1]{\renewcommand{\@hofassessmenttitle}{#1}}

\newcommand{\@hofduration}{}
\newcommand{\Duration}[1]{\renewcommand{\@hofduration}{#1}}

\setboolean{practice}{true}%
\setboolean{numbered}{true}%
\setboolean{assignment}{false}%
\setboolean{popquiz}{false}%
\setboolean{quiz}{false}%
\setboolean{mock}{false}%
\setboolean{midterm}{false}%
\setboolean{final}{false}%
\setboolean{makeup}{false}%
\setboolean{identity}{false}%
\setboolean{cover}{false}%
\setboolean{marking}{false}%
\setboolean{nobarcode}{false}%
\setboolean{noinstruct}{false}%
\setboolean{management}{false}%
\setboolean{formula}{false}%

\DeclareOption{practice}{\setboolean{practice}{true}%
  \setboolean{numbered}{true}%
  \setboolean{assignment}{false}%
  \setboolean{popquiz}{false}%
  \setboolean{quiz}{false}%
  \setboolean{mock}{false}%
  \setboolean{midterm}{false}%
  \setboolean{final}{false}%
  \setboolean{makeup}{false}%
  \setboolean{identity}{false}%
  \setboolean{cover}{false}%
  \setboolean{marking}{false}%
  \renewcommand{\@hofassessmenttitle}{\en{Practice assignment}\de{Übungsblatt}}}%
\DeclareOption{assignment}{\setboolean{assignment}{true}%
  \setboolean{numbered}{true}%
  \setboolean{practice}{false}%
  \setboolean{popquiz}{false}%
  \setboolean{quiz}{false}%
  \setboolean{mock}{false}%
  \setboolean{midterm}{false}%
  \setboolean{final}{false}%
  \setboolean{makeup}{false}
  \setboolean{identity}{true}%
  \setboolean{cover}{false}%
  \setboolean{marking}{true}%
  \renewcommand{\@hofassessmenttitle}{\en{Assignment}\de{Aufgabenblatt}}}%
\DeclareOption{popquiz}{\setboolean{popquiz}{true}%
  \setboolean{numbered}{true}%
  \setboolean{practice}{false}%
  \setboolean{assignment}{false}%
  \setboolean{quiz}{false}%
  \setboolean{mock}{false}%
  \setboolean{midterm}{false}%
  \setboolean{final}{false}%
  \setboolean{makeup}{false}
  \setboolean{identity}{true}%
  \setboolean{cover}{false}%
  \setboolean{marking}{true}%
  \renewcommand{\@hofassessmenttitle}{\en{Pop quiz}\de{Popquiz}}}%
\DeclareOption{quiz}{\setboolean{quiz}{true}%
  \setboolean{numbered}{true}%
  \setboolean{practice}{false}%
  \setboolean{assignment}{false}%
  \setboolean{popquiz}{false}%
  \setboolean{mock}{false}%
  \setboolean{midterm}{false}%
  \setboolean{final}{false}%
  \setboolean{makeup}{false}
  \setboolean{identity}{true}%
  \setboolean{cover}{false}%
  \setboolean{marking}{true}%
  \renewcommand{\@hofassessmenttitle}{\en{Quiz}\de{Quiz}}}%
\DeclareOption{mock}{\setboolean{mock}{true}%
  \setboolean{numbered}{false}%
  \setboolean{practice}{false}%
  \setboolean{assignment}{false}%
  \setboolean{popquiz}{false}%
  \setboolean{quiz}{false}%
  \setboolean{midterm}{false}%
  \setboolean{final}{false}%
  \setboolean{makeup}{false}
  \setboolean{identity}{false}%
  \setboolean{cover}{true}%
  \setboolean{marking}{false}%
  \renewcommand{\@hofassessmenttitle}{\en{Mock exam}\de{Probeklausur}}}%
\DeclareOption{midterm}{\setboolean{midterm}{true}%
  \setboolean{numbered}{false}%
  \setboolean{practice}{false}%
  \setboolean{assignment}{false}%
  \setboolean{popquiz}{false}%
  \setboolean{quiz}{false}%
  \setboolean{mock}{false}%
  \setboolean{final}{false}%
  \setboolean{makeup}{false}
  \setboolean{identity}{false}%
  \setboolean{cover}{true}%
  \setboolean{marking}{true}%
  \setcounter{@scratchpages}{3}%
  \renewcommand{\@hofduration}{120 \en{minutes}\de{Minuten}}%
  \renewcommand{\@hofassessmenttitle}{\en{Midterm exam}\de{Zwischenklausur}}}%
\DeclareOption{final}{\setboolean{final}{true}%
  \setboolean{numbered}{false}%
  \setboolean{practice}{false}%
  \setboolean{assignment}{false}%
  \setboolean{popquiz}{false}%
  \setboolean{quiz}{false}%
  \setboolean{mock}{false}%
  \setboolean{midterm}{false}%
  \setboolean{makeup}{false}
  \setboolean{identity}{false}%
  \setboolean{cover}{true}%
  \setboolean{marking}{true}%
  \setcounter{@scratchpages}{3}%
  \renewcommand{\@hofduration}{180 \en{minutes}\de{Minuten}}%
  \renewcommand{\@hofassessmenttitle}{\en{Final exam}\de{Klausur}}}%
\DeclareOption{makeup}{\setboolean{makeup}{true}%
  \setboolean{numbered}{false}%
  \setboolean{practice}{false}%
  \setboolean{assignment}{false}%
  \setboolean{popquiz}{false}%
  \setboolean{quiz}{false}%
  \setboolean{mock}{false}%
  \setboolean{midterm}{false}%
  \setboolean{final}{false}
  \setboolean{identity}{false}%
  \setboolean{cover}{true}%
  \setboolean{marking}{true}%
  \setcounter{@scratchpages}{3}%
  \renewcommand{\@hofduration}{180 \en{minutes}\de{Minuten}}%
  \renewcommand{\@hofassessmenttitle}{\en{Makeup exam}\de{Nachklausur}}}%

\DeclareOption{solution}{\setboolean{solution}{true}
  \setboolean{nomarktbl}{true}
  \setboolean{identity}{false}}%

\setboolean{logo}{false}%
\DeclareOption{logo}{\setboolean{logo}{true}}%

\setboolean{rightlogo}{false}%
\DeclareOption{rightlogo}{\setboolean{rightlogo}{true}}%

\DeclareOption{noid}{\setboolean{identity}{false}}%

\DeclareOption{nonumber}{\setboolean{numbered}{false}}%

\setboolean{nomarktbl}{false}%
\DeclareOption{nomarktbl}{\setboolean{nomarktbl}{true}}%

\DeclareOption{coverpage}{\setboolean{cover}{true}}%
\DeclareOption{nocover}{\setboolean{cover}{false}}%

\DeclareOption{nobarcode}{\setboolean{nobarcode}{true}}%

\DeclareOption{idform}{\setboolean{identity}{true}}%

\DeclareOption{noinstruct}{\setboolean{noinstruct}{true}}%

\DeclareOption{formula}{\setboolean{formula}{true}}%

\DeclareOption{english}{\PassOptionsToClass{english}{article}%
  \renewcommand\locale{en}%
  \AtEndOfClass{\main@language{english}}}%
\DeclareOption{german}{\PassOptionsToClass{german}{article}%
  \renewcommand\locale{de}%
  \AtEndOfClass{\main@language{german}}}%

\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}%
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}%
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}%

\ProcessOptions

\LoadClass[a4paper]{article}

%----------------------------------------------------------------------%
%   Languages

\localedef{de}{german}
\localedef{en}{english}

%----------------------------------------------------------------------%
%   Variables and commands

\newcommand{\@hofdate}{}
\newcommand{\Date}[1]{\renewcommand{\@hofdate}{#1}}

\renewcommand{\theassessment}{\arabic{assessment}}
\newcommand{\@assessmentform}{\@hofassessmenttitle\ifthenelse{\boolean{numbered}}{\ \theassessment}{}}
\newcommand{\Number}[1]{\setcounter{assessment}{#1}}

\renewcommand{\theexercise}{\ifthenelse{\boolean{numbered}}{\theassessment}{}%
  \ifthenelse{\equal{\@hofversion}{}}{}{(\@hofversion)}%
  \ifthenelse{\boolean{numbered}}{--}{}\arabic{exercise}}%

\newcommand{\@hofinst}{\en{Hof University of Applied Sciences}\de{Hochschule Hof}}
\newcommand{\Institute}[1]{\renewcommand{\@hofdpt}{#1}}

\newcommand{\@hofdpt}{\en{Institute of information systems (iisys)}\de{Institut für Informationssysteme (iisys)}}
\newcommand{\Department}[1]{\renewcommand{\@hofdpt}{#1}}

\newcommand{\@logofile}{\en{iisys_en}\de{iisys_de}}
\newcommand{\Logo}[1]{\renewcommand{\@logofile}{#1}\setboolean{logo}{true}}

\newcommand{\@rightlogofile}{HochschuleLogoEingepasst}
\newcommand{\Rightlogo}[1]{\renewcommand{\@rightlogofile}{#1}\setboolean{rightlogo}{true}}

\newcommand{\@hofclass}{LECTURE TITLE}
\newcommand{\Class}[1]{\renewcommand{\@hofclass}{#1}}

\newcommand{\@hofedition}{SEMESTER}
\newcommand{\Edition}[1]{\renewcommand{\@hofedition}{#1}}

\newcommand{\@hoflecturer}{RESPONSIBLE LECTURER}
\newcommand{\@hofshortlecturer}{LECTURER}
\newcommand{\Lecturer}[2][]{%
  \renewcommand{\@hofshortlecturer}{\ifthenelse{\equal{#1}{}}{#2}{#1}}%
  \renewcommand{\@hoflecturer}{#2}}

\newcommand{\@hofemail}{E-Mail}
\newcommand{\Email}[1]{\renewcommand{\@hofemail}{#1}}

\newcommand{\@hofsubtitle}{}
\newcommand{\Topic}[1]{\setboolean{subtitle}{true}\renewcommand\@hofsubtitle{#1}}

\newcommand{\@hofversion}{}
\newcommand{\Version}[1]{\renewcommand{\@hofversion}{#1}}

\newcommand{\Scratchpages}{\arabic{@scratchpages}}
\newcommand{\Scratchpaper}[1]{\setcounter{@scratchpages}{#1}}

\newcommand{\@spelled}[2][u]{%
  \ifthenelse{\equal{#1}{l}}%
  {\ifcase#2\or{\en{one}\de{ein}}\or{\en{two}\de{zwei}}\or{\en{three}\de{drei}}\or{\en{four}\de{vier}}\or{\en{five}\de{fünf}}\or{\en{six}\de{sechs}}\or{\en{seven}\de{sieben}}\or{\en{eight}\de{acht}}\or{\en{nine}\de{neun}}\or{\en{ten}\de{zehn}}\or{\en{eleven}\de{elf}}\or{\en{twelve}\de{zwölf}}\else\@ctrerr\fi}
  {\ifcase#2\or{\en{One}\de{Ein}}\or{\en{Two}\de{Zwei}}\or{\en{Three}\de{Drei}}\or{\en{Four}\de{Vier}}\or{\en{Five}\de{Fünf}}\or{\en{Six}\de{Sechs}}\or{\en{Seven}\de{Sieben}}\or{\en{Eight}\de{Acht}}\or{\en{Nine}\de{Neun}}\or{\en{Ten}\de{Zehn}}\or{\en{Eleven}\de{Elf}}\or{\en{Twelve}\de{Zwölf}}\else\@ctrerr\fi}}

\newcommand{\@scratchspelled}[1][u]{%
  \ifthenelse{\value{@scratchpages}>12}{\arabic{@scratchpages}}{\@spelled[#1]{\value{@scratchpages}}}}

\newcommand{\@mkscratch}%
{\multido{\i=1+1}{\value{@scratchpages}}{\newpage%
    \thispagestyle{scratch}
    \begin{center}
      \rule{\linewidth}{1pt}\\
      \raisebox{-.25\baselineskip}{\en{contents of the scratch paper
          will not be graded unless a reference on the problem page
          indicates that a solution extends here}\de{Diese Seite wird
          nur dann bewertet, wenn es bei der Aufgabe einen
          entsprechenden Verweis gibt.}}\\
      \rule{\linewidth}{1pt}
    \end{center}\stepcounter{@scratchpage}}}

\newcommand{\Pages}{\pageref{lastpage}}

\newcommand{\SolutionSpace}[1]{%
  \ifthenelse{\boolean{solution}}{}{\vspace*{#1}}}

\newcommand{\@hofinstructions}{%
  \begin{enumerate}
    \ifthenelse{\equal{\@hofduration}{}}{}{
    \item \en{The duration of this exam is
        \textbf{\@hofduration}.}\de{Diese Klausur dauert
        \textbf{\@hofduration}.} }
  \item \en{This exam booklet contains a total of \textbf{\Pages\
        pages}, including this one.}\de{Dieses Klausurheft besteht aus
      \textbf{\Pages\ Seiten}. } %
    \ifthenelse{\boolean{solution}}{%
      \ifthenelse{\boolean{formula}}{\en{A fomula sheet is attached
          and may be detached for convenience
          (page~\pageref{formulapage}).}\de{Eine Formelsammlung ist
          angehängt (Seite~\pageref{formulapage}) und kann der
          Einfachheit halber abgetrennt werden.} }{}}{%
      \ifthenelse{\value{@scratchpages}>0}{\ifthenelse{\boolean{marking}}{\@scratchspelled\
          \en{extra sheets of scratch paper are attached and have to
            be kept attached.}\de{zusätzliche Blätter sind als
            Konzeptpapier angehängt, und müssen im Heft verbleiben.}
        }{}}{}%
      \ifthenelse{\boolean{formula}}{\en{A fomula sheet is attached
          and may be detached for convenience
          (page~\pageref{formulapage}). The formula sheet does not
          need to be submitted.}\de{Eine Formelsammlung ist angehängt
          (Seite~\pageref{formulapage}) und kann der Einfachheit
          halber abgetrennt werden. Die Formelsammlung muss nicht mit
          abgegeben werden.} }{}%
      \textbf{\en{Note that if one or more pages are missing, you will
        lose their points. Thus, you must check whether your exam
        booklet is complete.}\de{Sollten eine oider mehrere Seiten
        fehlen, verlieren Sie gegebenenfalls die Punkte. Prüfen Sie
        daher, ob das Heft vollständig ist.}}
  \item \en{Write your solutions into the space
      provided.}\de{Schreiben Sie Ihre Lösungen in den dafür
      vorgesehenen Platz.} \en{If you need more space, write on the
      back of the sheet containing the problem}\de{Wenn Sie mehr Platz
      brauchen, nutzen Sie die Rückseite des
      Aufgabenblattes}\ifthenelse{\value{@scratchpages}>0}{\ifthenelse{\boolean{marking}}{
        \en{or on the \@scratchspelled[l]\ extra sheets and indicate
          that clearly on the problem page.}\de{oder die
          \@scratchspelled[l]\ zusätzlichen Blätter und verweisen Sie
          auf dem vorgesehenen Platz deutlich dorthin.}
        \textbf{\en{Scratch sheets will not be graded unless a
            reference on the problem page indicates that the solution
            extends to the scratch sheets.}\de{Lösungen auf dem
            Konzeptpapier werden nicht bewertet, wenn auf dem
            Aufgabenblatt kein entsprechender eindeutiger Verweis
            steht.}}}{.}}{.}}%
  \end{enumerate}}
\newcommand{\Instructions}[1]{\renewcommand{\@hofinstructions}{#1}}

\newcommand{\@hofmanagement}{}
\newcommand{\Management}[1]{%
  \setboolean{management}{true}%
  \renewcommand{\@hofmanagement}{#1}}

%----------------------------------------------------------------------%
%   Environments

%   Exercise
\newcommand{\@exercisename}{\en{Exercise}\de{Aufgabe}}
\newcommand{\Exercisename}[1]{\renewcommand{\@exercisename}{#1}}

\newcommand{\@bonusname}{\ifthenelse{\boolean{marking}}{\en{Bonus Exercise}\de{Bonusaufgabe}}{\en{Exercise}\de{Aufgabe}}}
\newcommand{\Bonusname}[1]{\renewcommand{\@bonusname}{#1}}

\newcommand{\@exerciseheadskip}{2em}
\newcommand{\Exerciseheadskip}[1]{\renewcommand{\@exerciseheadskip}{#1}}

\newcommand{\@exerciseskip}{%
  \ifthenelse{\value{exercise}=1}%
  {\par}%
  {\ifthenelse{\boolean{mock} \OR \boolean{midterm} \OR \boolean{final} \OR \boolean{makeup}}%
    {\newpage}{\vspace{\baselineskip}\par}}}%
\newcommand{\Exerciseskip}[1]{\renewcommand{\@exerciseskip}{#1}}

\newcommand{\@exerciselabel}{%
  \textbf{\@exercisename\ \theexercise}}

\newcommand{\@bonuslabel}{%
  \textbf{\@bonusname\ \theexercise}}

\newcommand{\@exerciselabelplusskip}{%
  \@exerciselabel\hspace*{\@exerciseheadskip}}

\newcommand{\@bonuslabelplusskip}{%
  \@bonuslabel\hspace*{\@exerciseheadskip}}

\newcommand{\@exercisemarks}[1]{%
  \ifthenelse{\boolean{marking}}{%
    \ifthenelse{\equal{#1}{}}%
    {}%
    {\ifthenelse{\equal{#1}{1}}%
      {(1~\en{Mark}\de{Punkt})}%
      {(#1~\en{Marks}\de{Punkte})}}}{}}%

\renewcommand{\labelenumi}{(\alph{enumi})}

\newcommand{\Mark}[1]{\addtocounter{@submarkstotal}{#1}\hspace*{\stretch{1}}{\@exercisemarks{#1}}}
\newcommand{\Bonus}[1]{\addtocounter{@subbonustotal}{#1}\hspace*{\stretch{1}}{\textbf{\@exercisemarks{#1}}}}

\newcommand{\@exercisetheme}[1]{%
  \ifthenelse{\equal{#1}{}}%
  {}%
  {\\\phantom{\@exerciselabelplusskip}\textbf{#1}}}%

\newcommand{\@bonustheme}[1]{%
  \ifthenelse{\equal{#1}{}}%
  {}%
  {\\\phantom{\@bonuslabelplusskip}\textbf{#1}}}%

\newcommand{\@exercisehead}[3]{%
  {\samepage
    \@exerciselabelplusskip{}#2\ifthenelse{\boolean{marking}}{\hfill\ifthenelse{\equal{#1}{}}{\textbf{\color{red}Marks
        not specified}}{\@exercisemarks{#1}}}{}\@exercisetheme{#3}\par\nopagebreak[4]}}

\newcommand{\@bonushead}[3]{%
  {\samepage
    \@bonuslabelplusskip{}#2\ifthenelse{\boolean{marking}}{\hfill\ifthenelse{\equal{#1}{}}{\textbf{\color{red}Marks
        not specified}}{\@exercisemarks{#1}}}{}\@bonustheme{#3}\par\nopagebreak[4]}}

\newcommand{\@addexercise}[1]{%
  \stepcounter{exercise}%
  \ifthenelse{\boolean{marking}}{
    \ifthenelse{\equal{#1}{}}{%
      \write\@mainaux{\noexpand\@writefile{loq}{%
          \noexpand\addtocounter{@marktableexercise}{1}%
          \noexpand\eaddto{\noexpand\marksrow}{?&}}}}
    {%
      \write\@mainaux{\noexpand\@writefile{loq}{%
          \noexpand\addtocounter{@marktotal}{#1}%
          \noexpand\addtocounter{@marktableexercise}{1}%
          \noexpand\eaddto{\noexpand\marksrow}{#1&}}}}}{}}

\newcommand{\@addbonus}[1]{%
  \stepcounter{exercise}%
  \ifthenelse{\boolean{marking}}{
    \ifthenelse{\equal{#1}{}}{%
      \write\@mainaux{\noexpand\@writefile{loq}{%
          \noexpand\addtocounter{@marktableexercise}{1}%
          \noexpand\eaddto{\noexpand\marksrow}{Bonus: ?&}}}}
    {%
      \write\@mainaux{\noexpand\@writefile{loq}{%
          \noexpand\addtocounter{@marktableexercise}{1}%
          \noexpand\eaddto{\noexpand\marksrow}{Bonus: #1&}}}}}{}}

\newenvironment{exercise}[3]{%
  \ifthenelse{\equal{#1}{}}{\setcounter{@currentmarks}{0}}{\setcounter{@currentmarks}{#1}}%
  \@addexercise{#1}\@exerciseskip\@exercisehead{#1}{#2}{#3}}{%
  \ifthenelse{\boolean{marking}}{%
    \ifthenelse{\value{@submarkstotal}>0}{%
      \ifthenelse{\value{@currentmarks}=\value{@submarkstotal}}{}{%
        ~\\\textbf{\color{red} Subproblem marks don't add up:
          Specified marks: \arabic{@currentmarks}, Sum of
          subproblems: \arabic{@submarkstotal}, Bonus: \arabic{@subbonustotal}}}}{}}{}}

\newenvironment{bonusexercise}[3]{%
  \@addbonus{#1}\@exerciseskip\@bonushead{#1}{#2}{#3}}{}

%   Solution
\newcommand{\solutionskip}{%
  \vspace{\baselineskip}\par}

\newcommand{\solutionheading}{%
  {\samepage\textbf{\en{Solution}\de{Lösung}:}\par\nopagebreak[4]}}

\newenvironment{solution}%
{\ifthenelse{\boolean{solution}}%
  {\solutionskip\solutionheading}%
  {\comment}}%
{\ifthenelse{\boolean{solution}}%
  {}%
{\endcomment}}

\newenvironment{unsolved}%
{\ifthenelse{\boolean{solution}}%
  {\comment}%
  {}}%
{\ifthenelse{\boolean{solution}}%
  {\endcomment}%
  {}}

\newcommand{\checkedItem}{\item[\ifthenelse{\boolean{solution}}{$\checkmark\hspace*{-1em}\square$}{$\square$}]}%
\newenvironment{mcq}%
{\renewcommand{\labelitemi}{$\square$}%
  \renewcommand{\labelitemii}{$\square$}%
  \renewcommand{\labelitemiii}{$\square$}%
  \renewcommand{\labelitemiv}{$\square$}%
  \begin{itemize}}
{\end{itemize}}

%----------------------------------------------------------------------%
%   Convenient automatic functions by Igor Akkerman

%   Extracting assessment number
%   \extractleadingnumber {<string>} {<countername>}
\newcommand{\extractleadingnumber}[2]{%
  \setbox0=\hbox{\global\csname c@#2\endcsname 0#1\relax}%
}
%   \extractnumber {<string>} {<countername>}
\newcommand{\extractnumber}[2]{%
  \def\@restof##1##2!!!{##2}%
  \def\@remblank##1##2!!!{##1##2}%
  \edef\@string{#1}%
  \extractleadingnumber\@string{#2}%
  \whiledo{\(\not \equal{\@string}{}\) \and \value{#2} = 0} {%
    \edef\@string{\expandafter\@restof\@string!!!}%
    \edef\@string{\expandafter\@remblank\@string!!!}%
    \extractleadingnumber\@string{#2}%
  }%
}
\ifthenelse{\boolean{numbered}}{%
  \extractnumber{\jobname}{assessment}}{%
  \setcounter{assessment}{0}}
\typeout{[hofuniversity] file name: \jobname}
\typeout{[hofuniversity] assessment number: \theassessment}

%   Searching and loading of config.tex
\typeout{[hofuniversity] Searching 'config.tex'}
\InputIfFileExists{./config.tex}{%
  \typeout{[hofuniversity] File 'config.tex' found in current directory. loading.}}%
{
  \InputIfFileExists {../config.tex}{%
    \graphicspath{{../}}
    \typeout{[hofuniversity] File 'config.tex' found in parent directory. loading.}}%
  {
    \InputIfFileExists {../../config.tex}{%
      \graphicspath{{../../}}
      \typeout{[hofuniversity] File 'config.tex' found in second parent directory. loading.}}%
    {
      \typeout{[hofuniversity] File 'config.tex' not found.}
    }
  }
}

%----------------------------------------------------------------------%
%   Magic (necessary for creating the table of results)

%   building lines with tab marker symbols
\def\addto#1#2{%
  \ifx#1\@undefined
    \def#1{#2}%
  \else
    \ifx#1\relax
      \def#1{#2}%
    \else
      {\toks@\expandafter{#1#2}%
        \xdef#1{\the\toks@}}%
    \fi
  \fi}
\newcommand*\eaddto[2]{%
  \edef\tmp{#2}%
  \expandafter\addto
  \expandafter#1%
  \expandafter{\tmp}}%

%----------------------------------------------------------------------%
%   Table of results

\newsavebox\@ignore
\newcommand{\@hofmarktable}{%
  \def\numbersrow{}%
  \def\marksrow{}%
  \def\emptyrow{}%
  \savebox\@ignore{\@starttoc{loq}}
  \begin{tabular}{| >{\columncolor[gray]{0.9}}r | *{\value{@marktableexercise}}{c |}| c |}
    \hline
    \rowcolor[gray]{0.9}\@exercisename
    \multido{\i=1+1}{\value{@marktableexercise}}{\eaddto\numbersrow{&\i}}\numbersrow & $\Sigma$ \\
    \hline
    \rowcolor[gray]{0.9}\en{Possible marks}\de{Erreichbare Punkte} & \marksrow \textbf{\arabic{@marktotal}} \\
    \hline
    \hline
    \raisebox{-.75em}{\en{Final marks}\de{Bewertung}}
    \multido{\i=1+1}{\value{@marktableexercise}}{\eaddto\emptyrow{&\noexpand\hspace*{2em}}}\emptyrow & \hspace*{3em} \\[1.5em]
    \hline
  \end{tabular}}

%----------------------------------------------------------------------%
%   Formula sheet

%   TODO: Formulas should be inside an environment rather than a
%         command. Use \detokenize\BODY with the environ package to
%         implement such a solution.

%   Bug: Formulas without title will print the label of the last, not
%        of the current exercise!

\newcommand{\@hofwriteoutformula}[2]{\write\@mainaux{\noexpand\@writefile{for}{%
      \detokenize{\item[#1]~\\#2}}}}

\newcommand{\AddFormula}[2][]{%
  \ifthenelse{\boolean{formula}}{%
    \ifthenelse{\equal{#1}{}}{%
      \@hofwriteoutformula{\en{Formula}\de{Formel}}{#2}}{%
%      \@hofwriteoutformula{\lbrack\@exerciselabel\rbrack}{#2}}{%
      \@hofwriteoutformula{#1}{#2}}
    \ifthenelse{\boolean{formula}}{}{%
      \typeout{[hofuniversity] Warning: Formulas specified but formula sheet
        not attached. Use option "formula"}}}{%
    \typeout{[hofuniversity] Warning: Formulas specified but formula sheet
      not attached. Use option "formula"}
    \textbf{\ifthenelse{\equal{#1}{}}{\en{Formulas.}\de{Formeln.}}{#1.}}\\[\@exerciseheadskip]#2}}

\newcommand{\@mkformula}%
{\newpage%
  \thispagestyle{formula}
  \label{formulapage}
  \ifthenelse{\boolean{marking}}{%
    \begin{center}
      \rule{\linewidth}{1pt}\\
      \raisebox{-.25\baselineskip}{\en{The formula sheet can be
          detached for convenience. It does not have to be
          submitted.}\de{Diese Formelsammlung kann aus dem Arbeitsheft
          gelöst werden. Die
          Formlesammlung muss nicht abgegeben werden.}}\\
      \rule{\linewidth}{1pt}
    \end{center}}{}
  \begin{description}
    \@starttoc{for}
    \item[~] ~
  \end{description}}

%----------------------------------------------------------------------%
%   Identity

\newcommand{\@hofidentity}{%
  \vspace*{1cm}
  {\large Name}\dotfill%
  \begin{tabular}[b]{|r|*{8}{p{1.5em}|}}
    \hline
    \raisebox{-.75em}{Student ID \#} & & &
    \raisebox{-.75em}{\parbox{\linewidth}{\centering \textbf{---}}}
    & & & & & \\[1.5em]
    \hline
  \end{tabular}%
  \\[1cm]
  {\large Name of your TA}\dotfill%
  \begin{tabular}[b]{|r|*{4}{p{1.5em}|}}
    \hline
    \raisebox{-.75em}{Group \#} &
    \raisebox{-.75em}{\parbox{\linewidth}{\centering \textbf{T}}} &
    \raisebox{-.75em}{\parbox{\linewidth}{\centering \textbf{---}}} & & \\[1.5em]
    \hline
  \end{tabular}%
  \\}

\newcommand{\@barcodebox}{%
  \fbox{%
    \begin{minipage}{10cm}
      \vspace*{30mm}
      \begin{flushright}
        {\small\textbf{Barcode}}
      \end{flushright}
    \end{minipage}}}

%----------------------------------------------------------------------%
%   Layout and headings

\geometry{paper=a4paper, left=15mm, right=15mm, top=10mm, bottom=10mm,
  headheight=3\baselineskip, includehead, includefoot}
\pagestyle{fancy}
\lhead{\ifthenelse{\boolean{logo}}{
    \includegraphics[height=.8\headheight]{\@logofile}
    \hspace*{1mm}
    \begin{minipage}[b]{.4\linewidth}
      \small\bfseries\sf \@hofclass\\\@hofedition\\~
    \end{minipage}}
  {\small\bfseries\sf \@hofclass\\\@hofedition\\~}}
\chead{}
\rhead{\ifthenelse{\boolean{rightlogo}}{
    \begin{minipage}[b]{.4\linewidth}
      \flushright{\small\sf \@hofinst\\\@hofdpt\\\@hofshortlecturer}
    \end{minipage}
    \hspace*{1mm}
    \includegraphics[height=.8\headheight]{\@rightlogofile}}
  {\small\sf \@hofinst\\\@hofdpt\\\@hofshortlecturer}}
\lfoot{\bfseries \@assessmentform}
\cfoot{}
\rfoot{\en{Page}\de{Seite} \thepage/\pageref{lastpage}}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}

\fancypagestyle{plain}{
  \fancyhf{}
  \rfoot{\en{Page}\en{Seite} \thepage/\pageref{lastpage}}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0.4pt}}

\fancypagestyle{scratch}{
  \lhead{}%
  \chead{\large\textbf{\en{Scratch paper sheet}\de{Konzeptpapier Blatt} \arabic{@scratchpage}}}%
  \rhead{}%
  \lfoot{\@hofclass\ (\@hofedition)}%
  \cfoot{\textbf{\@assessmentform,\ \@hofdate}}}%

\fancypagestyle{formula}{
  \lhead{}%
  \chead{\large\textbf{\en{Formula sheet}\de{Formlesammlung}}}%
  \rhead{}%
  \lfoot{\@hofclass\ (\@hofedition)}%
  \cfoot{\textbf{\@assessmentform,\ \@hofdate}}}%

\parindent0pt
\parskip1\baselineskip

%----------------------------------------------------------------------%
%   Titleline / coverpage

\AtBeginDocument{%
  \ifthenelse{\boolean{cover}}{%
    \newgeometry{left=15mm, right=15mm, top=10mm, bottom=10mm, headheight=0pt, includefoot}
    \thispagestyle{plain}
    \noindent
    \ifthenelse{\boolean{logo}}{%
      \includegraphics[height=2\baselineskip+1em]{\@logofile}\hspace*{1mm}}{}
    \begin{minipage}[b]{.5\linewidth}
      \bfseries\sf \@hofinst\\\@hofdpt\\\@hoflecturer
    \end{minipage}
    \hspace*{\stretch{1}}
    \begin{minipage}[b]{.2\linewidth}
      \flushright{\ifthenelse{\equal{\@hofdate}{}}{\typeout{[hofuniversity]
            Warning: Date not specified.}{\bfseries\color{red}Define
            date!}}{\bfseries\sf\@hofdate}}\\~\\~
    \end{minipage}\ifthenelse{\boolean{rightlogo}}{%
      \hspace*{3mm}\includegraphics[height=2\baselineskip+1em]{\@rightlogofile}}{}
    \vspace*{3\baselineskip}
    \begin{center}
      \textbf{\LARGE\@hofclass\\[5mm]}
      \textbf{\Large\@hofedition\\[5mm]}
      {\Large \@assessmentform\\[1cm]}
      \ifthenelse{\boolean{marking}}{%
        \ifthenelse{\boolean{identity}}{\@hofidentity}{%
          \ifthenelse{\boolean{nobarcode} \OR
            \boolean{solution}}{}{\@barcodebox}}}{}%
      \ifthenelse{\boolean{solution}}{
        \rule{\linewidth}{2pt}
        \raisebox{-.25\baselineskip}{\bfseries Model Solutions}
        \rule{\linewidth}{2pt}}{}%
    \end{center}
    \ifthenelse{\boolean{noinstruct}{}}{}{%
      \ifthenelse{\boolean{mock}}{\textbf{Typical regulations of an exam like this:}}%
      {\textbf{Instructions. Please read carefully before proceeding.}}
      \@hofinstructions}
    \ifthenelse{\boolean{management}}{%
      \@hofmanagement}{}
    \begin{center}
      \ifthenelse{\boolean{mock} \OR \boolean{solution}}{}{
        \textbf{\large Good luck!}}
    \end{center}
    \vspace*{\stretch{1}}
    \ifthenelse{\boolean{marking}}{\ifthenelse{\boolean{nomarktbl}}{}{
    \rule{\linewidth}{3pt}
    Do not write anything below this line.
    \begin{center}
      \@hofmarktable
    \end{center}}}{}
    \restoregeometry
    \pagebreak
  }{%
    \noindent
    \begin{center}
      {\LARGE \bfseries \@assessmentform}\\[2mm]
      \ifthenelse{\boolean{subtitle}}{{\Large\@hofsubtitle\\[2mm]}}{}
      \ifthenelse{\equal{\@hofversion}{}}{}{{\large ---\ Version\ \@hofversion\ ---\\[2mm]}}
      {\ifthenelse{\equal{\@hofdate}{}}{\ifthenelse{\boolean{marking}}{\typeout{[hofuniversity]
            Warning: Date not specified.}{\bfseries\color{red}Define
            submission date!\\}}{}}{%
          \rule{\linewidth}{2pt}
          \raisebox{-.25\baselineskip}{%
            \ifthenelse{\boolean{solution}}{\bfseries \en{Model Solutions}\de{Musterlösung}}{%
              \ifthenelse{\boolean{quiz}\OR\boolean{popquiz}}{}
              {\ifthenelse{\boolean{marking}}{\bfseries \en{Submission}\de{Abgabe}: }{\en{Discussion}\de{Besprechung}: }}{\@hofdate}}}
          \rule{\linewidth}{2pt}}}
    \end{center}
    \ifthenelse{\boolean{identity}}{\@hofidentity}{}
    \ifthenelse{\boolean{management}}{\vspace*{1cm}

      \@hofmanagement}{}
    \ifthenelse{\boolean{marking}}{\ifthenelse{\boolean{nomarktbl}}{}{
        \vspace*{2cm}
        \begin{center}
          {\small \en{Do \textbf{not} write anything into this
              table!}\de{Diese Tabelle \textbf{nicht} beschreiben!}}\\
          \@hofmarktable
        \end{center}\vspace*{2cm}}}{}
  }}

\AtEndDocument{%
  \ifthenelse{\boolean{solution}}{}{\ifthenelse{\boolean{marking}}{\@mkscratch}{}}%
  \ifthenelse{\boolean{formula}}{\@mkformula}{}%
  \label{lastpage}%
}

%----------------------------------------------------------------------%
\makeatother
