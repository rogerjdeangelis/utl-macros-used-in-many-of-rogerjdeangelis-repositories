%macro utl_pdftotext(inp,out)
  / des="convert a pdf to text";
  %utl_submit_r64x("
    library(tm);
    library(pdftools);
    file<-'&inp';
    Rpdf<-readPDF(
      control=list(text='-layout'));
    corpus<-VCorpus(URISource(file),
    readerControl=list(reader=Rpdf));
    want<-content(content(corpus)[[1]]);
    write(want,file='&out');
    lines<-unlist(strsplit(want,'\n'));
    non_empty_lines<-
      lines[!grepl('^\\s*$',lines)];
    write(non_empty_lines
      ,file='table.txt');
  ");
%mend utl_pdftotext;
