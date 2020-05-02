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
    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    var gerenciadorLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cria o gerenciador do mapa
        gerenciadorLocalizacao.delegate = self
        
        // Acuracia e autorização
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Recupera a ultima localização do usuário
        let localizacaoUsuario = locations.last!
        
        // Recupera a latitude e longitude
        let longitude = localizacaoUsuario.coordinate.longitude
        let latitude = localizacaoUsuario.coordinate.latitude
        
        // Seta na tela
        self.longitudeLabel.text = String(longitude)
        self.latitudeLabel.text = String(latitude)
        
        if localizacaoUsuario.speed > 0 {
            self.velocidadeLabel.text = String(localizacaoUsuario.speed)
        }
        
        // Aproximação do mapa inicial
        let deltaLatitude: CLLocationDegrees = 0.01
        let deltaLogintute: CLLocationDegrees = 0.01
        
        // Localização em 2D
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        
        // Area que esta sendo exibida e seu zoom
        let areaExibicao: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: deltaLatitude, longitudeDelta: deltaLogintute)
        
        // Regiao que está sendo exibida
        let regiao: MKCoordinateRegion = MKCoordinateRegion.init(center: localizacao, span: areaExibicao)
        mapa.setRegion(regiao, animated: true)
        
        // Pegar endereço
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { (detalhesLocal, error) in
            if error == nil {
                if let dadosLocal = detalhesLocal?.first {
                
                    var thoroughfare = ""
                    if dadosLocal.thoroughfare != nil {
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    
                    var locality = ""
                    if dadosLocal.locality != nil {
                        locality = dadosLocal.locality!
                    }
                    
//                    var subLocality = ""
//                    if dadosLocal.subLocality != nil {
//                        subLocality = dadosLocal.subLocality!
//                    }
//
//                    var postalCode = ""
//                    if dadosLocal.postalCode != nil {
//                        postalCode = dadosLocal.postalCode!
//                    }
//
                    var country = ""
                    if dadosLocal.country != nil {
                        country = dadosLocal.country!
                    }
//
//                    var administrativeArea = ""
//                    if dadosLocal.administrativeArea != nil {
//                        administrativeArea = dadosLocal.administrativeArea!
//                    }
//
//                    var subAdministrativeArea = ""
//                    if dadosLocal.subAdministrativeArea != nil {
//                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
//                    }
                    
                    self.enderecoLabel.text = thoroughfare + " - "
                                                    + subThoroughfare + " / "
                                                    + locality + " / "
                                                    + country
                    
                }
                
            }else {
                print(error)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alertaController = UIAlertController(title: "Permissao de localização", message: "Necessário permissão para acesso à sua localização! por favor, habilite.", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertaController.addAction(acaoConfiguracoes)
            alertaController.addAction(acaoCancelar)
            
            present(alertaController, animated: true, completion: nil)
        }
    }


}

