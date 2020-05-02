//
//  ViewController.swift
//  Onde estou
//
//  Created by Victor Rodrigues Novais on 29/04/20.
//  Copyright © 2020 Victoriano. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            var alertaController = UIAlertController(title: "Permissao de localização", message: "Necessário permissão para acesso à sua localização! por favor, habilite.", preferredStyle: .alert)
            
            var acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default) { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    
                    UIApplication.shared.open(configuracoes as URL)
                    
                }
            }
            
            var acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        }
    }


}

