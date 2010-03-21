require 'spec_helper'

describe LoanApplication do
  before(:each) do
    @app = Factory.create(:loan_application)
  end

  it "should create a new instance given valid attributes" do
    @app.should be_valid
  end
  
  describe "#signer" do
    before(:each) do
      @signer = @app.signer
    end
    
    it "should return a Docusign::Recipient" do
      @signer.should be_an_instance_of(Docusign::Recipient)
    end
    
    it "should set the signer id" do
      @signer.id.should == 1
    end
    
    it "should set the signer email" do
      @signer.email.should == @app.email
    end
    
    it "should set the signer user_name" do
      @signer.user_name.should == @app.full_name
    end
    
    it "should set require_id_lookup to false" do
      @signer.require_id_lookup.should be_false
    end
    
    it "should set the type to Signer" do
      @signer.type.should == Docusign::RecipientTypeCode::Signer
    end
    
    it "should set captive info" do
      @signer.captive_info.should be_an_instance_of Docusign::RecipientCaptiveInfo
    end
    
    it "should set the signature info" do
      @signer.signature_info.should be_an_instance_of Docusign::RecipientSignatureInfo
    end
    
    it "should set the signature initials" do
      @signer.signature_info.signature_initials.should == 'JD'
    end
    
    it "should set the signature font style" do
      @signer.signature_info.font_style.should == Docusign::FontStyleCode::Mistral
    end
    
    it "should set the signature full name" do
      @signer.signature_info.signature_name.should == @app.full_name
    end
  end
  
  describe "#document" do
    before(:each) do
      @document = @app.document
    end
    
    it "should return a Docusign::Document" do
      @document.should be_an_instance_of Docusign::Document 
    end
    
    it "should set the document id to 1" do
      @document.id.should == 1
    end
    
    it "should name the document 'loan'" do
      @document.name.should == 'loan'
    end
    
    it "should read the pdf_bytes of the document from the loan pdf file" do
      @document.pdf_bytes.should == Base64.encode64(File.read(LoanApplication::PDF_PATH))
    end
    
    it "should create 5 tabs" do
      @document.tabs.size.should == 5
    end
  end
  
  describe "#envelope" do
    before(:each) do
      @envelope = @app.envelope
    end
    
    it "should create a Docusign::Envelope" do
      @envelope.should be_an_instance_of Docusign::Envelope
    end
    
    it "should set the envelope's sole recipient to the loan application's signer" do
      @envelope.recipients.should == [@app.signer]
    end
    
    it "should set the envelope's only document to the loan app's document" do
      @envelope.documents.should == [@app.document]
    end
    
    it "should set the envelope's tabs to the document's tabs" do
      @envelope.tabs.should == @app.document.tabs
    end
  end
  
  describe "#initials" do
    it "should return the applicant's initials" do
      @app.initials.should == 'JD'
    end
  end
end
