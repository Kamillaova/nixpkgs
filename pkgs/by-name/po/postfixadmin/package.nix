{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "postfixadmin";
  version = "3.3.14";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-T7KRD0ihtWcvJB6pZxXThFHerL5AGd8+mCg8UIXPZ4g=";
  };

  patches = [
    # Fix https://github.com/postfixadmin/postfixadmin/issues/872
    (fetchpatch2 {
      url = "https://github.com/postfixadmin/postfixadmin/commit/8ec9140673afd9996a3f81cca600ea0e5bd31cf8.patch";
      hash = "sha256-OLkWeVL5ryuIONb/RF6Uv7UQDfVsbEkrx50rMDungGI=";
    })
  ];

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/postfixadmin/config.local.php $out/
    ln -sf /var/cache/postfixadmin/templates_c $out/
  '';

  passthru.tests = { inherit (nixosTests) postfixadmin; };

  meta = {
    description = "Web based virtual user administration interface for Postfix mail servers";
    homepage = "https://postfixadmin.sourceforge.io/";
    maintainers = with lib.maintainers; [ globin ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
