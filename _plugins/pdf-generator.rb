module Jekyll

PDF_DIR = File.expand_path("../", __FILE__)+'/../'

    class PDFGenerator < Generator
        
        safe false
        
        def generatePDF(page)
            system('weasyprint http://0.0.0.0:4000'+page.url+' '+PDF_DIR+page.data['PDFTitle']+'.pdf')
            system('echo --------------------')
            system('echo Done Generating PDF '+page.url+' '+PDF_DIR+page.data['PDFTitle']+'.pdf')
        end
        
        def generate(site)
            site.pages.each do |page|
                if (page.data.has_key?('isPDF'))
                    generatePDF(page)
                end
            end
        end
    end
    
end
