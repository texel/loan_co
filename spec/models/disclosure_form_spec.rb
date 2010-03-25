require 'spec_helper'

describe DisclosureForm do
  before(:each) do
    @form = Factory.create(:disclosure_form)
  end

  it "should create a new instance given valid attributes" do
    @form.should_not be_new_record
  end
  
  describe "#signer" do
    before(:each) do
      @signer = @form.signer
    end
    
    it "should return a Docusign::Recipient" do
      @signer.should be_an_instance_of(Docusign::Recipient)
    end
    
    it "should set the signer id" do
      @signer.id.should == 1
    end
    
    it "should set the signer email" do
      @signer.email.should == @form.email
    end
    
    it "should set the signer user_name" do
      @signer.user_name.should == @form.full_name
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
      @signer.signature_info.signature_initials.should == 'DJ'
    end
    
    it "should set the signature font style" do
      @signer.signature_info.font_style.should == Docusign::FontStyleCode::Mistral
    end
    
    it "should set the signature full name" do
      @signer.signature_info.signature_name.should == @form.full_name
    end
  end
  
  describe "#document" do
    before(:each) do
      @document = @form.document
    end
    
    it "should return a Docusign::Document" do
      @document.should be_an_instance_of Docusign::Document 
    end
    
    it "should set the document id to 1" do
      @document.id.should == 1
    end
    
    it "should name the document 'disclosure'" do
      @document.name.should == 'disclosure'
    end
    
    it "should read the pdf_bytes of the document from the loan pdf file" do
      @document.pdf_bytes.should == Base64.encode64(File.read(DisclosureForm::PDF_PATH))
    end
    
    it "should create 11 tabs" do
      @document.tabs.size.should == 11
    end
  end
  
  describe "#envelope" do
    before(:each) do
      @envelope = @form.envelope
    end
    
    it "should create a Docusign::Envelope" do
      @envelope.should be_an_instance_of Docusign::Envelope
    end
    
    it "should set the envelope's sole recipient to the loan application's signer" do
      @envelope.recipients.should == [@form.signer]
    end
    
    it "should set the envelope's only document to the loan app's document" do
      @envelope.documents.should == [@form.document]
    end
    
    it "should set the envelope's tabs to the document's tabs" do
      @envelope.tabs.should == @form.document.tabs
    end
  end
end
