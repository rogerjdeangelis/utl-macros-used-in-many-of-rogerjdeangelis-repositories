%Macro utl_pptlan100
    (
      style=utl_pptlan100
      ,frame=box
      ,TitleFont=22pt
      ,docfont=18pt
      ,fixedfont=18pt
      ,rules=ALL
      ,bottommargin=.25in
      ,topmargin=1.5in
      ,rightmargin=.5in
      ,leftmargin=.5in
      ,cellheight=16pt
      ,cellpadding = 2pt
      ,cellspacing = 2pt
      ,borderwidth = 1pt
    ) /  Des="SAS PPT Template for Powerpoint";

ods path work.templat(update) sasuser.templat(update) sashelp.tmplmst(read);

Proc Template;

   define style &Style;
   parent=styles.rtf;

        replace body from Document /

               protectspecialchars=off
               asis=on
               bottommargin=&bottommargin
               topmargin   =&topmargin
               rightmargin =&rightmargin
               leftmargin  =&leftmargin
               ;

        replace color_list /
              'link' = blue
               'bgH'  = _undef_
               'fg'  = black
               'bg'   = _undef_;

        replace fonts /
               'TitleFont2'           = ("Arial, Helvetica, Helv",&titlefont,Bold)
               'TitleFont'            = ("Arial, Helvetica, Helv",&titlefont,Bold)

               'HeadingFont'          = ("Arial, Helvetica, Helv",&titlefont)
               'HeadingEmphasisFont'  = ("Arial, Helvetica, Helv",&titlefont,Italic)

               'StrongFont'           = ("Arial, Helvetica, Helv",&titlefont,Bold)
               'EmphasisFont'         = ("Arial, Helvetica, Helv",&titlefont,Italic)

               'FixedFont'            = ("Courier New, Courier",&fixedfont)
               'FixedEmphasisFont'    = ("Courier New, Courier",&fixedfont,Italic)
               'FixedStrongFont'      = ("Courier New, Courier",&fixedfont,Bold)
               'FixedHeadingFont'     = ("Courier New, Courier",&fixedfont,Bold)
               'BatchFixedFont'       = ("Courier New, Courier",&fixedfont)

               'docFont'              = ("Arial, Helvetica, Helv",&docfont)

               'FootFont'             = ("Arial, Helvetica, Helv", 9pt)
               'StrongFootFont'       = ("Arial, Helvetica, Helv",8pt,Bold)
               'EmphasisFootFont'     = ("Arial, Helvetica, Helv",8pt,Italic)
               'FixedFootFont'        = ("Courier New, Courier",8pt)
               'FixedEmphasisFootFont'= ("Courier New, Courier",8pt,Italic)
               'FixedStrongFootFont'  = ("Courier New, Courier",7pt,Bold);

        replace GraphFonts /
               'GraphDataFont'        = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphValueFont'       = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphLabelFont'       = ("Arial, Helvetica, Helv",&fixedfont,Bold)
               'GraphFootnoteFont'    = ("Arial, Helvetica, Helv",8pt)
               'GraphTitleFont'       = ("Arial, Helvetica, Helv",&TitleFont,Bold)
               'GraphAnnoFont'        = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphUnicodeFont'     = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphLabel2Font'      = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphTitle1Font'      = ("Arial, Helvetica, Helv",&TitleFont,Bold);

        style table from table /
                outputwidth=100%
                protectspecialchars=off
                asis=on
                background = colors('tablebg')
                frame=&frame
                rules=&rules
                cellheight  = &cellheight
                cellpadding = &cellpadding
                cellspacing = &cellspacing
                bordercolor = colors('tableborder')
                borderwidth = &borderwidth;

         replace Footer from HeadersAndFooters

                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off ;

                replace FooterFixed from Footer
                / font = fonts('FixedFootFont')  just=left asis=on protectspecialchars=off;

                replace FooterEmpty from Footer
                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off;

                replace FooterEmphasis from Footer
                / font = fonts('EmphasisFootFont')  just=left asis=on protectspecialchars=off;

                replace FooterEmphasisFixed from FooterEmphasis
                / font = fonts('FixedEmphasisFootFont')  just=left asis=on protectspecialchars=off;

                replace FooterStrong from Footer
                / font = fonts('StrongFootFont')  just=left asis=on protectspecialchars=off;

                replace FooterStrongFixed from FooterStrong
                / font = fonts('FixedStrongFootFont')  just=left asis=on protectspecialchars=off;

                replace RowFooter from Footer
                / font = fonts('FootFont')  asis=on protectspecialchars=off just=left;

                replace RowFooterFixed from RowFooter
                / font = fonts('FixedFootFont')  just=left asis=on protectspecialchars=off;

                replace RowFooterEmpty from RowFooter
                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off;

                replace RowFooterEmphasis from RowFooter
                / font = fonts('EmphasisFootFont')  just=left asis=on protectspecialchars=off;

                replace RowFooterEmphasisFixed from RowFooterEmphasis
                / font = fonts('FixedEmphasisFootFont')  just=left asis=on protectspecialchars=off;

                replace RowFooterStrong from RowFooter
                / font = fonts('StrongFootFont')  just=left asis=on protectspecialchars=off;

                replace RowFooterStrongFixed from RowFooterStrong
                / font = fonts('FixedStrongFootFont')  just=left asis=on protectspecialchars=off;

                replace SystemFooter from TitlesAndFooters / asis=on
                        protectspecialchars=off just=left;
    end;
run;
quit;

%Mend utl_pptlan100;
