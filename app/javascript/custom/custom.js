if (document.querySelector(".image-uploader")) {
  window.addEventListener("load", () => {
    const uploader = document.querySelector(".image-uploader");
    uploader.addEventListener("change", () => {
      const upload_file = uploader.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(upload_file);
      reader.addEventListener("load", () => {
        const upload_image = reader.result;
        document.querySelector(".edit-profile-image").setAttribute("src", upload_image);
      });
    });
  });
};
