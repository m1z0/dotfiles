function encryptDecryptId() {
  var $idInput = $("#merchantIdInput");
  var $errorOutput = $("#merchantIdError").text("");
  var txt = $idInput.val();

  if (txt === "") {
    return;
  }

  try {
    if (/^[0-9]+$/.test(txt)) {
      $idInput.val(AmzId.encrypt(txt)).select();
    }
    else if (/^[0-9A-Z]+$/.test(txt)) {
      $idInput.val(AmzId.decrypt(txt)).select();
    }
    else {
      throw Error("Cannot encrypt/decrypt \"" + txt + "\": ID must be numeric (0-9) or contain upper-case letters (A-Z)");
    }
    ignoreNextHashChange = true;
    window.location.hash = "#encrypt=" + txt;
  }
  catch (e) {
    $errorOutput.text(e.message);
  }
}
