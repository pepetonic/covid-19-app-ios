//
//  ViewController.swift
//  AppCovidInfo
//
//  Created by Mac5 on 14/12/20.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cargar Api al iniciar la app
        cargarInfo()
    }
    
    func cargarInfo(){
        
        let urlAPI = URL(string: "https://corona.lmao.ninja/v3/covid-19/countries/")
        
        let peticion = URLRequest(url: urlAPI!)
        
        let tarea = URLSession.shared.dataTask(with: peticion){datos,respuesta,error in
            //
            if error != nil {
                print(error!)
            }else {
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    /*
                    let pais = json["country"] as! String
                    //let stringPais = pais as! String
                    if pais == ""{
                        DispatchQueue.main.sync {
                            let page = "<h1 style = 'font-size: 100px'>ESTADO GENERAL</h1><ul><li>\(pais)</li></ul>"
                            self.webView.loadHTMLString(page, baseURL: nil)
                        }
                    }else{
                        DispatchQueue.main.sync {
                            self.webView.loadHTMLString("<h1>\(pais)</h1>", baseURL: nil)
                        }
                    }*/
                    
                } catch{
                    print("Error al procesar el Json \(error.localizedDescription)")
                }
            }
            
        }
        tarea.resume()
    }

    @IBAction func buscarPais(_ sender: UIBarButtonItem) {
    }
}

