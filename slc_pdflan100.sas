%Macro slc_pdflan100
    (
      style=slc_pdflan100
      ,outputwidth=100%
      ,frame=box
      ,TitleFont=11pt
      ,docfont=10pt
      ,fixedfont=9pt
      ,rules=none
      ,bottommargin=.25in
      ,topmargin=1.5in
      ,rightmargin=1.0in
      ,leftmargin=.75in
      ,cellheight=13pt
      ,cellpadding = 7pt
      ,cellspacing = 3pt
      ,borderwidth = 1
    ) /  Des="SAS PDF Template for PDF";

/* ods path work.templat(update) sasuser.templat(update) sashelp.tmplmst(read); */

Proc Template;

   define style &Style;
   

         style body from Document /

               protectspecialchars=off
               asis=on
               bottommargin=&bottommargin
               topmargin   =&topmargin
               rightmargin =&rightmargin
               leftmargin  =&leftmargin
               ;

         style color_list /
              'link' = blue
               'bgH'  = _undef_
               'fg'  = _undef_
               'bg'   = _undef_;

         style fonts /
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
 
        style Graph from Output/
                outputwidth = 100% ;
 
        style table from table /
                outputwidth=&outputwidth
                protectspecialchars=off
                asis=on
                /* background = colors('tablebg') */
                frame=&frame
                rules=&rules
                cellheight  = &cellheight
                cellpadding = &cellpadding
                cellspacing = &cellspacing
                bordercolor = colors('tableborder')
                borderwidth = &borderwidth;

          style Footer from HeadersAndFooters

                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off ;

                 style FooterFixed from Footer
                / font = fonts('FixedFootFont')  just=left asis=on protectspecialchars=off;

                 style FooterEmpty from Footer
                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off;

                 style FooterEmphasis from Footer
                / font = fonts('EmphasisFootFont')  just=left asis=on protectspecialchars=off;

                 style FooterEmphasisFixed from FooterEmphasis
                / font = fonts('FixedEmphasisFootFont')  just=left asis=on protectspecialchars=off;

                 style FooterStrong from Footer
                / font = fonts('StrongFootFont')  just=left asis=on protectspecialchars=off;

                 style FooterStrongFixed from FooterStrong
                / font = fonts('FixedStrongFootFont')  just=left asis=on protectspecialchars=off;

                 style RowFooter from Footer
                / font = fonts('FootFont')  asis=on protectspecialchars=off just=left;

                 style RowFooterFixed from RowFooter
                / font = fonts('FixedFootFont')  just=left asis=on protectspecialchars=off;

                 style RowFooterEmpty from RowFooter
                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off;

                 style RowFooterEmphasis from RowFooter
                / font = fonts('EmphasisFootFont')  just=left asis=on protectspecialchars=off;

                 style RowFooterEmphasisFixed from RowFooterEmphasis
                / font = fonts('FixedEmphasisFootFont')  just=left asis=on protectspecialchars=off;

                 style RowFooterStrong from RowFooter
                / font = fonts('StrongFootFont')  just=left asis=on protectspecialchars=off;

                 style RowFooterStrongFixed from RowFooterStrong
                / font = fonts('FixedStrongFootFont')  just=left asis=on protectspecialchars=off;

                 style SystemFooter from TitlesAndFooters / asis=on
                        protectspecialchars=off just=left;
    end;
run;
quit;

%Mend slc_pdflan100;
