with import <nixpkgs> {};
''
  cdrrserv(){
    cd ~/code/2_rr/HCMServer
  }
  cdrrwebui(){
    cd ~/code/2_rr/EdluminUI
  }
  cdcap(){
    cd ~/code/1_personal/aa-cap
  }
  open-rider() {
    rider $1 &>/dev/null &
  }
  echo "
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖
          ▜███▙       ▜███▙  ▟███▛        
           ▜███▙       ▜███▙▟███▛            
            ▜███▙       ▜██████▛             
     ▟█████████████████▙ ▜████▛     ▟▙      
    ▟███████████████████▙ ▜███▙    ▟██▙    
           ▄▄▄▄▖           ▜███▙  ▟███▛      
          ▟███▛             ▜██▛ ▟███▛       
         ▟███▛               ▜▛ ▟███▛         
▟███████████▛                  ▟██████████▙   
▜██████████▛                  ▟███████████▛  
      ▟███▛ ▟▙               ▟███▛          
     ▟███▛ ▟██▙             ▟███▛          
    ▟███▛  ▜███▙           ▝▀▀▀▀           
    ▜██▛    ▜███▙ ▜██████████████████▛     
     ▜▛     ▟████▙ ▜████████████████▛     
           ▟██████▙       ▜███▙          
          ▟███▛▜███▙       ▜███▙      
         ▟███▛  ▜███▙       ▜███▙     
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘        

cdrrserv = opens RR server directory
cdrrwebui = opens RR web client directory
cdcap = opens aa-cap directory
open-rider = opens rider at specified directory
  "
''