%Macro utl_rtflan100
    (
      style=utl_rtflan100,
      frame=box,
      rules=groups,
      outputwidth=100%,
      bottommargin=1.0in,
      topmargin=1.5in,
      rightmargin=1.0in,
      cellheight=10pt,
      cellpadding = 7,
      cellspacing = 3,
      leftmargin=.75in,
      borderwidth = 1
    ) /  Des="SAS Rtf Template for CompuCraft";

options orientation=landscape;run;quit;

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
               'TitleFont2'           = ("Arial, Helvetica, Helv",11pt,Bold)
               'TitleFont'            = ("Arial, Helvetica, Helv",11pt,Bold)

               'HeadingFont'          = ("Arial, Helvetica, Helv",10pt)
               'HeadingEmphasisFont'  = ("Arial, Helvetica, Helv",10pt,Italic)

               'StrongFont'           = ("Arial, Helvetica, Helv",10pt,Bold)
               'EmphasisFont'         = ("Arial, Helvetica, Helv",10pt,Italic)

               'FixedFont'            = ("Courier New, Courier",9pt)
               'FixedEmphasisFont'    = ("Courier New, Courier",9pt,Italic)
               'FixedStrongFont'      = ("Courier New, Courier",9pt,Bold)
               'FixedHeadingFont'     = ("Courier New, Courier",9pt,Bold)
               'BatchFixedFont'       = ("Courier New, Courier",7pt)

               'docFont'              = ("Arial, Helvetica, Helv",10pt)

               'FootFont'             = ("Arial, Helvetica, Helv", 9pt)
               'StrongFootFont'       = ("Arial, Helvetica, Helv",8pt,Bold)
               'EmphasisFootFont'     = ("Arial, Helvetica, Helv",8pt,Italic)
               'FixedFootFont'        = ("Courier New, Courier",8pt)
               'FixedEmphasisFootFont'= ("Courier New, Courier",8pt,Italic)
               'FixedStrongFootFont'  = ("Courier New, Courier",7pt,Bold);

        replace GraphFonts /
               'GraphDataFont'        = ("Arial, Helvetica, Helv",8pt)
               'GraphAnnoFont'        = ("Arial, Helvetica, Helv",8pt)
               'GraphValueFont'       = ("Arial, Helvetica, Helv",10pt)
               'GraphUnicodeFont'     = ("Arial, Helvetica, Helv",10pt)
               'GraphLabelFont'       = ("Arial, Helvetica, Helv",10pt,Bold)
               'GraphLabel2Font'      = ("Arial, Helvetica, Helv",10pt,Bold)
               'GraphFootnoteFont'    = ("Arial, Helvetica, Helv",8pt)
               'GraphTitle1Font'      = ("Arial, Helvetica, Helv",11pt,Bold)
               'GraphTitleFont'       = ("Arial, Helvetica, Helv",11pt,Bold);

        style table from table /
                outputwidth=&outputwidth
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

%Mend utl_rtflan100;
