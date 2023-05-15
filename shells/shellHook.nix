''
  cdrrserv(){
    cd ~/code/2_rr/HCMServer
  }
  cdrrwebui(){
    cd ~/code/2_rr/EdluminUI
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
open-rider = opens rider at specified directory
  "
''