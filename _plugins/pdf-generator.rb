module Jekyll

    class PDFGenerator < Generator
        safe false
        
        def generate(site)
            site.pages.each do |post|
                if (post.data.has_key?('isPDF'))
                    system('echo --------------------')
                    system('weasyprint http://0.0.0.0:4000'+post.url+' ~/Desktop/'+post.name+'.pdf')
                    system('echo Done Generating PDF '+post.name)
                    system('echo --------------------')
                end
            end
        end
    end
    
end