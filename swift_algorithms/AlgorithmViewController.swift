
import UIKit

final class AlgorithmResultsPresenter: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
    
    var properties: [BasicTableRowController.Properties] = []
    var deliver: (([BasicTableRowController.Properties]) -> Void)?
    
    var searchedProperties: [BasicTableRowController.Properties] = [] {
        didSet {
            deliver?(searchedProperties)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            searchedProperties = properties.filter { item in
                return (item.title + (item.subtitle ?? "")).lowercased().contains(text.lowercased())
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

final class ResultsTableViewController: SectionProxyTableViewController {
    private let section = BasicTableSectionController()
    private let empty = SearchEmptyStateView()
    
    weak var dispatcher: RowActionDispatching?
    
    var properties: [BasicTableRowController.Properties] = [] {
        didSet {
            update(with: properties.map(BasicTableRowController.map))
        }
    }
    
    func update(with properties: [RowController]) {
        section.rows = properties
        section.dispatcher = dispatcher
        tableView.reloadData()
        
        if properties.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            empty.isHidden = false
            view.bringSubview(toFront: empty)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        section.registerReusableTypes(tableView: tableView)
        sections = [section]
        tableView.tableFooterView = UIView()
        tableView.backgroundView = empty
        tableView.backgroundView?.isHidden = true

    }
}




final class AlgorithmViewController: SectionProxyTableViewController {
    weak var dispatcher: RowActionDispatching?
    let header = QuadrantSelectorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    private let footer = DonateFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(with sections: [TableSectionController]) {
        sections.forEach { section in
            section.registerReusableTypes(tableView: tableView)
        }
        
        self.sections = sections
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
        tableView.backgroundColor = .groupTableViewBackground
        
        // Setup the Search Controller
        definesPresentationContext = true
        
//        header
        let items = [
            QuadrantItemView.Properties(title: "Search", image: UIImage(named: "search"), backgroundColor: .turquiose()),
            QuadrantItemView.Properties(title: "Compress", image: UIImage(named: "zip"), backgroundColor: .flatRed()),
            QuadrantItemView.Properties(title: "Sort", image: UIImage(named: "filter"), backgroundColor: .amethist()),
            QuadrantItemView.Properties(title: "Math", image: UIImage(named: "math"), backgroundColor: .orangeCream()),
            ]
        
        header.configure(with: items)
        
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentMD)))
        
//        end header
        

        
        
        
    }
    
    enum Action {
        case whatAreAlgorithms
        case whyLearnAlgorithms
        case bigO
        case designTechniques
        case howToContribute
        
        case stack
        case queue
        case insertionSort
        case binarySearch
        case binarySearchTree
        case mergeSort
        case boyerMoore
        
        // Searching
        
        case linnearSearch
        case countOccurences
        case selectMinMax
        case kthLargestElement
        case selectionSampling
        case unionFind
        
        // String Search
        
        case bruteForceStringSearch
        case knuthMorrisPratt
        case rabinKarp
        case longestCommonSubsequence
        case zAlgorithm
        
        // Sorting
        
        case selectionSort
        case shellSort
        case quickSort
        case heapSort
        case introSort
        case countingSort
        case radixSort
        case topologicalSort
        case bubbleSort
        case slowSort
        
        // Compression
        
        case runLengthEncoding
        case huffmanCoding
        
        // Miscellaneous
        
        case shuffle
        case comboSort
        case convexHull
        case millerRabin
        case minimumCoin
        
        // Mathematics
        
        case gcd
        case permutationsAndCombinations
        case shuntingYard
        case karatsubaMultiplication
        case haversineDistance
        case strassenMultiplicationMatrix
        
        // Machine Learning
        
        case kMeansClustering
        case linnearRegression
        case naiveBayesClassifier
        case simulatedAnnealing
        
        
        var title: String {
            switch self {
            case .whatAreAlgorithms: return "Pancakes!"
            case .whyLearnAlgorithms: return "Why Learn?"
            case .bigO: return "Big O"
            case .designTechniques: return "Design Techniques"
            case .howToContribute: return "How To Contribute"
            default: return ""
            }
        }
    }
    
    
    @objc func presentMD() {
        let modal = MarkdownPresentationViewController()
        navigationController?.pushViewController(modal, animated: true)
    }
}
