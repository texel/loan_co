class LoanApplication < ActiveRecord::Base
  PDF_PATH = Rails.root.join('public/docs/loan.pdf')
    
  validates_presence_of :amount, :full_name, :email, :phone
  
  # Output and store a Docusign::Recipient for this Loan Application
  #
  # Populates captive signer information and signature information.
  
  def signer
    @signer ||= Docusign::Recipient.new.tap do |s|
      s.id        = 1
      s.email     = email
      s.user_name = full_name
      s.type      = Docusign::RecipientTypeCode::Signer
      
      s.require_id_lookup = false
      
      s.captive_info = Docusign::RecipientCaptiveInfo.new.tap do |i|
        i.client_user_id = Time.now.to_i
      end
      
      s.signature_info = Docusign::RecipientSignatureInfo.new.tap do |i|
        i.signature_initials = initials
        i.font_style         = Docusign::FontStyleCode::Mistral
        i.signature_name     = full_name
      end
    end
  end
  
  # Output and store a Docusign::Document object for this Loan Application
  #
  # The Docusign gem extends Docusign::Document and enables it to store an array
  # of tabs. This makes it simple to build a document, then build its corresponding
  # tabs, without having to pass the document_id into each tab.
  
  def document
    @document ||= Docusign::Document.new.tap do |d|
      d.id = 1
      d.name = 'loan'
      d.pdf_bytes = Base64.encode64(File.read(PDF_PATH))
      
      # Create tabs
      d.tabs signer do |d|
        d.tab :name => 'email', :value => email,        :anchor => {:string => 'E-mail:', :x_offset => 200, :y_offset => -2}
        d.tab :name => 'phone', :value => phone,        :anchor => {:string => 'Phone:',  :x_offset => 200, :y_offset => -2}
        d.tab :type => Docusign::TabTypeCode::FullName, :anchor => {:string => 'Name:',   :x_offset => 200, :y_offset => -2}
        d.tab :name => 'amount', :value => amount,      :anchor => {:string => 'Amount:', :x_offset => 200, :y_offset => -2}
        d.tab :type => Docusign::TabTypeCode::SignHere, :anchor => {:string => 'X:',      :x_offset => 30,  :y_offset =>  8}
      end
    end
  end
  
  # Prepare a Docusign::Envelope with this Loan Application's signer, document, and tabs
  
  def envelope
    @envelope ||= Docusign::Envelope.new.tap do |e|
      e.recipients = [signer]
      e.documents  = [document]
      e.tabs       = document.tabs
    end
  end
  
  def initials
    full_name.to_s.split(' ').map(&:first).map(&:upcase).join
  end
end
