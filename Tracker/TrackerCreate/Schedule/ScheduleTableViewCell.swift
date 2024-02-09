
import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    var scheduleSwitchAction: ((Bool) -> Void)?
    
     lazy var scheduleSwitch: UISwitch = {
        let scheduleSwitch = UISwitch()
        scheduleSwitch.translatesAutoresizingMaskIntoConstraints = false
        scheduleSwitch.onTintColor = .ypBlue
        scheduleSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return scheduleSwitch
    }()
    lazy var titleSchedule: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.textColor = .ypBlack
       label.font = .hugeTitleMedium17
       label.textAlignment = .center
       return label
   }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubScheduleViews()
        setupScheduleConstraints()
        setupContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func setupScheduleConstraints(){
        NSLayoutConstraint.activate([
            scheduleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleSchedule.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleSchedule.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupContentView(){
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .ypBackgroundDay
    }
    private func addSubScheduleViews(){
        contentView.addSubview(scheduleSwitch)
        contentView.addSubview(titleSchedule)
    }
    
    @objc func switchAction(_ sender: UISwitch) {
        scheduleSwitchAction?(sender.isOn)
    }
}

